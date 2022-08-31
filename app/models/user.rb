# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  has_many :courses, dependent: :nullify, inverse_of: :user # nullify - при удалении пользователя, остануться его действия
  has_many :enrollments, dependent: :nullify, inverse_of: :user
  has_many :user_lessons, dependent: :nullify
  has_many :comments, dependent: :nullify # чтобы комментарии оставались даже если пользователя не существует
  validate :must_have_a_role, on: :update

  rolify

  def to_s
    email
  end

  # Google Omniauth doesn't support raw addresses so use localhost aka 127.0.0.1 to log in
  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    # Uncomment the section below if you want users to be created if they don't exist
    if user # if user account exists - add additional data
      user.name = access_token.info.name
      user.image = access_token.info.image
      user.provider = access_token.provider
      user.uid = access_token.uid
      user.token = access_token.credentials.token
      user.expires_at = access_token.credentials.expires_at
      user.expires = access_token.credentials.expires
      user.refresh_token = access_token.credentials.refresh_token
      user.save!
    else
      user = User.create(
        email: data['email'],
        name: access_token.info.name,
        image: access_token.info.image,
        provider: access_token.provider,
        uid: access_token.uid,
        token: access_token.credentials.token,
        expires_at: access_token.credentials.expires_at,
        expires: access_token.credentials.expires,
        refresh_token: access_token.credentials.refresh_token,
        password: Devise.friendly_token[0,20],
        confirmed_at: Time.zone.now # autoconfirm user from omniauth
      )
    end
    user
  end

  def username
    email.split(/@/).first
  end

  def online?
    updated_at > 2.minutes.ago
  end

  def buy_course(course)
    enrollments.create(course: course, price: course.price)
  end

  def view_lesson(lesson)
    user_lesson = user_lessons.where(lesson: lesson) # Ищем уроки пользователя
    if user_lesson.any?
      user_lesson.first.increment!(:impressions) # Увеличиваем число просмотров урока
    else
      user_lessons.create(lesson: lesson) # Если урока не существует, то создаем запись в таблице user_lessons
    end
  end

  extend FriendlyId
  friendly_id :email, use: :slugged

  # Баг с коллбеком, задваивание ролей.
  # Решается переносом коллбека после rolify или заменой колбека на after_commit
  after_create :assign_default_role # after_commit :assign_default_role, on: :create

  private

  # def assign_default_role
  #   add_role(:student) if roles.blank?
  # end
  def assign_default_role
    if User.count == 1
      add_role(:admin) if roles.blank?
      add_role(:teacher)
      add_role(:student)
    else
      add_role(:student) if roles.blank?
      add_role(:teacher) # if you want any user to be able to create own courses
    end
  end

  def must_have_a_role
    errors.add(:roles, 'must have at least one role') unless roles.any?
  end
end
