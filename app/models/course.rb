class Course < ApplicationRecord
  extend FriendlyId

  validates :title, :description, presence: true
  validates :description, length: { minimum: 5 }
  belongs_to :user
  def to_s
    title
  end
  has_rich_text :description

  friendly_id :title, use: :slugged

# def generated_slug
# require 'securerandom'
# @random_slug ||= persisted? ? friendly_id : SecureRandom.hex(4)
end
