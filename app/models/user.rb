class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable

  def to_s
    email
  end
  has_many :courses, dependent: :destroy
end
