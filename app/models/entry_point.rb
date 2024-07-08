class EntryPoint < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness:  { :message => "This name is already taken." }

  after_create :create_parking_slots

  private

  def create_parking_slots
    [
      { size: 'sp', distances: { id.to_s => 1 }.to_json, occupied: false },
      { size: 'mp', distances: { id.to_s => 2 }.to_json, occupied: false },
      { size: 'lp', distances: { id.to_s => 3 }.to_json, occupied: false }
    ].each_with_index do |slot_params, index|
      ParkingSlot.create(
        size: slot_params[:size],
        distances: slot_params[:distances],
        occupied: slot_params[:occupied],
        name: "#{name}#{index + 1}"
      )
    end
  end
end
