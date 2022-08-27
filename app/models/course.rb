# frozen_string_literal: true

class Course < ApplicationRecord
  extend FriendlyId
  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user } # set activity owner to current_user by default

  validates :title, :short_description, :language, :level, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true, length: { minimum: 5 }
  belongs_to :user, counter_cache: true
  # User.find_each { |user| User.reset_counters(user.id, :courses) }  Update counter_cache
  has_many :lessons, dependent: :destroy, inverse_of: :course
  has_many :enrollments, dependent: :restrict_with_error, inverse_of: :course # Запрет на удаление курса, если есть подписки. Флеш сообщение настраивается в контроллере
  has_many :user_lessons, through: :lessons # Для того чтобы учесть уроки для курса

  validates :title, uniqueness: true

  scope :latest, -> { limit(3).order(created_at: :desc) }
  scope :top_rated, -> { limit(3).order(average_rating: :desc, created_at: :desc) }
  scope :popular, -> { limit(3).order(enrollments_count: :desc, created_at: :desc) }
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where(approved: false) }

  has_one_attached :avatar
  def to_s
    title
  end
  has_rich_text :description

  friendly_id :title, use: :slugged

  def bought?(user)
    enrollments.where(user_id: [user.id], course_id: [id]).any?
  end

  # Количество уроков созданных конкретным пользователем / на количество уроков в курсе
  # В процентном соотношении
  # Прогресс показывается только в случае наличия уроков
  def progress(user)
    user_lessons.where(user: user).count / lessons_count.to_f * 100 unless lessons_count.zero?
  end

  def update_rating
    if enrollments.any? && enrollments.where.not(rating: nil).any? # Course has many enrollments!
      update_column :average_rating, enrollments.average(:rating).round(2).to_f
    else
      update_column :average_rating, 0
    end
  end

  LANGUAGES = %i[English Russian Polish Spanish].freeze
  def self.languages
    LANGUAGES.map { |language| [language, language] }
  end

  LEVELS = [:'All levels', :Beginner, :Intermediate, :Advanced].freeze

  def self.levels
    LEVELS.map { |level| [level, level] }
  end
  # Метод генерации зашифрованного пути к конкретному ресурсу вместо id
  # def generated_slug
  # require 'securerandom'
  # @random_slug ||= persisted? ? friendly_id : SecureRandom.hex(4)
end
