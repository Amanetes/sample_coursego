# frozen_string_literal: true

class Enrollment < ApplicationRecord
  belongs_to :course, counter_cache: true # в момент изменения enrollment, связанное поле enrollments_count будет обновлено
  # Course.find_each { |course| Course.reset_counters(course.id, :enrollments) } Update counter_cache for enrollments count
  belongs_to :user, counter_cache: true
  # User.find_each { |user| User.reset_counters(user.id, :enrollments) }  Update counter_cache

  # если есть рейтинг, то должно быть и review и наоборот
  validates :rating, presence: { if: :review? }
  validates :review, presence: { if: :rating? }

  validates :user_id, uniqueness: { scope: :course_id }  # user cant be subscribed to the same course twice
  validates :course_id, uniqueness: { scope: :user_id }  # user cant be subscribed to the same course twice

  validate :cant_subscribe_to_own_course # user can't create a subscription if course.user == current_user.id

  scope :pending_review, -> { where(rating: [0, nil, ''], review: [0, nil, '']) }
  scope :reviewed, -> { where.not(review: [0, nil, '']) }
  scope :latest_good_reviews, -> { order(rating: :desc, created_at: :desc).limit(3) }

  extend FriendlyId
  friendly_id :to_s, use: :slugged
  def to_s
    "#{user} #{course}"
  end

  after_save do
    course.update_rating unless rating.nil? || rating.zero? # Избегает лишних запросов по обновлению рейтинга
  end

  after_destroy do
    course.update_rating
  end

  protected

  def cant_subscribe_to_own_course
    errors.add(:base, 'You cannot subscribe to your own course') if new_record? && user_id.present? && (user_id == course.user_id)
  end
end
