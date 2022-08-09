# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable
  has_many :courses, dependent: :destroy, inverse_of: :user
  has_many :enrollments, dependent: :destroy, inverse_of: :user
  validate :must_have_a_role, on: :update

  rolify

  def to_s
    email
  end

  def username
    email.split(/@/).first
  end

  def online?
    updated_at > 2.minutes.ago
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
