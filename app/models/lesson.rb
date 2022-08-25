# frozen_string_literal: true

class Lesson < ApplicationRecord
  belongs_to :course, inverse_of: :lessons, counter_cache: true
  # Course.find_each { |course| Course.reset_counters(course.id, :lessons) } Update counter_cache

  validates :title, :content, presence: true # :course_id не нужно указывать явно

  extend FriendlyId
  friendly_id :title, use: :slugged

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  has_rich_text :content

  def to_s
    title
  end
end
