class ParkingSession < ApplicationRecord
  belongs_to :vehicle
  belongs_to :parking_slot

  validates :entry_time, presence: true
end
