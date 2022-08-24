# frozen_string_literal: true

class Course < ApplicationRecord
  extend FriendlyId
  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user } # set activity owner to current_user by default

  validates :title, :short_description, :language, :level, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true, length: { minimum: 5 }
  belongs_to :user
  has_many :lessons, dependent: :destroy, inverse_of: :course
  has_many :enrollments, dependent: :destroy, inverse_of: :course
  def to_s
    title
  end
  has_rich_text :description

  friendly_id :title, use: :slugged

  def bought?(user)
    enrollments.where(user_id: [user.id], course_id: [id]).empty?
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

  LEVELS = %i[Beginner Intermediate Advanced].freeze
  def self.levels
    LEVELS.map { |level| [level, level] }
  end
  # Метод генерации зашифрованного пути к конкретному ресурсу вместо id
  # def generated_slug
  # require 'securerandom'
  # @random_slug ||= persisted? ? friendly_id : SecureRandom.hex(4)
end
