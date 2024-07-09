# test/services/slot_finder_test.rb
require 'test_helper'

class SlotFinderTest < ActiveSupport::TestCase
  def setup
    @vehicle_small = vehicles(:small_vehicle)
    @vehicle_medium = vehicles(:medium_vehicle)
    @vehicle_large = vehicles(:large_vehicle)

    @entry_point2 = entry_points(:two)

    @small_slot = ParkingSlot.create(name: 'B1', size: :sp, distances: { @entry_point2.id.to_s => 2 }.to_json, occupied: false)
    @medium_slot = ParkingSlot.create(name: 'B2', size: :mp, distances: { @entry_point2.id.to_s => 1 }.to_json, occupied: false)
    @large_slot = ParkingSlot.create(name: 'B3', size: :lp, distances: { @entry_point2.id.to_s => 3 }.to_json, occupied: false)
  end

  # If both small and medium parking slots near the entry point are available,
  # the system will prioritize assigning a small vehicle to the small slot first,
  # even if the medium slot is closer.

  test 'find suitable slots for small vehicle' do
    slot_finder = SlotFinder.new(@vehicle_small, @entry_point2)
    assigned_slot = slot_finder.find_suitable_slot

    assert_equal assigned_slot, @small_slot
  end
end
