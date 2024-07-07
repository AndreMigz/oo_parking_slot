# test/services/slot_finder_test.rb
require 'test_helper'

class SlotFinderTest < ActiveSupport::TestCase
  def setup
    @vehicle_small = vehicles(:small_vehicle)
    @vehicle_medium = vehicles(:medium_vehicle)
    @vehicle_large = vehicles(:large_vehicle)

    @entry_point2 = entry_points(:two)

    @small_slot = ParkingSlot.create(name: 'B1', size: :sp, distances: { @entry_point2.id.to_s => 1 }.to_json, occupied: false)
    @medium_slot = ParkingSlot.create(name: 'B2', size: :mp, distances: { @entry_point2.id.to_s => 2 }.to_json, occupied: false)
    @large_slot = ParkingSlot.create(name: 'B3', size: :lp, distances: { @entry_point2.id.to_s => 3 }.to_json, occupied: false)
  end

  test 'find suitable slots for small vehicle' do
    slot_finder = SlotFinder.new(@vehicle_small)
    suitable_slots = slot_finder.find_suitable_slots

    assert_includes suitable_slots, @small_slot
    assert_includes suitable_slots, @medium_slot
    assert_includes suitable_slots, @large_slot
  end

  test 'find slots near entry point' do
    slot_finder = SlotFinder.new(@vehicle_medium)
    suitable_slots = slot_finder.find_suitable_slots

    slots_near_entry = slot_finder.find_slots_near_entry(suitable_slots, @entry_point2.id.to_s)

    assert_includes slots_near_entry, @medium_slot
    assert_includes slots_near_entry, @large_slot
    refute_includes slots_near_entry, @small_slot
  end

  test 'find slots near any entry point' do
    slot_finder = SlotFinder.new(@vehicle_large)
    suitable_slots = slot_finder.find_suitable_slots

    slots_near_any_entry = slot_finder.find_slots_near_any_entry(suitable_slots)

    assert_includes slots_near_any_entry, @large_slot
    refute_includes slots_near_any_entry, @small_slot
    refute_includes slots_near_any_entry, @medium_slot
  end
end
