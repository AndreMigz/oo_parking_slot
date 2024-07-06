class Vehicle < ApplicationRecord
  has_many :parking_sessions

  enum size: { small: 0, medium: 1, large: 2 }

  validates :size, presence: true
end
