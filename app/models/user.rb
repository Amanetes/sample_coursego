# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable
  has_many :courses, dependent: :destroy
  def to_s
    email
  end

  def username
    self.email.split(/@/).first
  end
end
