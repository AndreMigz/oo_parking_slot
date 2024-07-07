class ParkingSlot < ApplicationRecord
  has_many :parking_sessions

  enum size: { sp: 0, mp: 1, lp: 2 }

  validates :name, presence: true
  validates :size, presence: true
  validates :distances, presence: true
end
