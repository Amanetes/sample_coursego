# frozen_string_literal: true

class Lesson < ApplicationRecord
  belongs_to :course

  validates :title, :content, presence: true # :course_id не нужно указывать явно

  extend FriendlyId
  friendly_id :title, use: :slugged

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  def to_s
    title
  end
end
