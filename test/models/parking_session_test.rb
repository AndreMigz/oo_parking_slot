require "test_helper"

class ParkingSessionTest < ActiveSupport::TestCase
  setup do
    @vehicle = Vehicle.create(size: :small)
    @parking_slot = ParkingSlot.create(size: :sp, distances: 100)
    @parking_session = ParkingSession.new(vehicle: @vehicle, parking_slot: @parking_slot, entry_time: Time.now)
  end

  test 'should be valid' do
    assert @parking_session.valid?
  end

  test 'vehicle should be present' do
    @parking_session.vehicle = nil
    assert_not @parking_session.valid?
  end

  test 'parking_slot should be present' do
    @parking_session.parking_slot = nil
    assert_not @parking_session.valid?
  end

  test 'entry_time should be present' do
    @parking_session.entry_time = nil
    assert_not @parking_session.valid?
  end
end
