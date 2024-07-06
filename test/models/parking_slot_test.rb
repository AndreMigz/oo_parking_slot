require "test_helper"

class ParkingSlotTest < ActiveSupport::TestCase
  setup do
    @parking_slot = ParkingSlot.new(size: :sp, distances: 100)
  end

  test 'should be valid' do
    assert @parking_slot.valid?
  end

  test 'size should be present' do
    @parking_slot.size = nil
    assert_not @parking_slot.valid?
  end

  test 'distances should be present' do
    @parking_slot.distances = nil
    assert_not @parking_slot.valid?
  end

  test 'should have correct enum values' do
    assert_equal 0, ParkingSlot.sizes[:sp]
    assert_equal 1, ParkingSlot.sizes[:mp]
    assert_equal 2, ParkingSlot.sizes[:lp]
  end

  test 'should have many parking sessions' do
    assert_respond_to @parking_slot, :parking_sessions
  end
end
