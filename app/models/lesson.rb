# frozen_string_literal: true

class Lesson < ApplicationRecord
  belongs_to :course, inverse_of: :lessons, counter_cache: true
  has_many :user_lessons, dependent: :destroy
  has_many :comments, dependent: :nullify
  # Course.find_each { |course| Course.reset_counters(course.id, :lessons) } Update counter_cache

  validates :title, :content, presence: true # :course_id не нужно указывать явно
  validates :title, length: { maximum: 70 }
  validates :title, uniqueness: { scope: :course_id } # scope - в разных курсах могут быть уроки с одинаковым названием, но в одном не могут

  extend FriendlyId
  friendly_id :title, use: :slugged

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  has_rich_text :content
  has_one_attached :video
  has_one_attached :video_thumbnail

  validates :video,
            content_type: ['video/mp4'],
            size: { less_than: 50.megabytes, message: 'size should be under 50 megabytes' }
  validates :video_thumbnail,
            content_type: %w[image/png image/jpg image/jpeg],
            size: { less_than: 500.kilobytes, message: 'size should be under 500 kilobytes' }

  # Валидирует video_thumbnail если присутствует видео
  # validates :video_thumbnail, presence: true, if: :video_present?
  # def video_present?
  #  video.present?
  # end

  include RankedModel
  ranks :row_order, with_same: :course_id

  def to_s
    title
  end

  def prev
    course.lessons.where('row_order < ?', row_order).order(:row_order).last
  end

  def next
    course.lessons.where('row_order > ?', row_order).order(:row_order).first
  end

  def viewed?(user)
    user_lessons.where(user: user).present?
    # self.user_lessons.where(user_id: [user.id], lesson_id: [self.id]).present? # same as above
  end
end
