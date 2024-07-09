require 'test_helper'

class ParkingServiceTest < ActiveSupport::TestCase
  setup do
    @entry_point = entry_points(:two)
    @vehicle_small = Vehicle.create(size: :small)
    @vehicle_medium = Vehicle.create(size: :medium)
    @vehicle_large = Vehicle.create(size: :large)

    @small_slot = ParkingSlot.create(name: 'B1', size: :sp, distances: { @entry_point.id.to_s => 1 }.to_json, occupied: false)
    @medium_slot = ParkingSlot.create(name: 'B2', size: :mp, distances: { @entry_point.id.to_s => 2 }.to_json, occupied: false)
    @large_slot = ParkingSlot.create(name: 'B3', size: :lp, distances: { @entry_point.id.to_s => 3 }.to_json, occupied: false)
  end

  test "park small vehicle in SP slot" do
    ParkingService.new(@entry_point, @vehicle_small).park_vehicle

    assert @small_slot.reload.occupied
  end

  test "park medium vehicle in MP slot" do
    ParkingService.new(@entry_point, @vehicle_medium).park_vehicle

    assert @medium_slot.reload.occupied
  end

  test "park large vehicle in LP slot" do
    ParkingService.new(@entry_point, @vehicle_large).park_vehicle

    assert @large_slot.reload.occupied
  end

  test "vehicle returns within an hour" do
    service = ParkingService.new(@entry_point, @vehicle_small)

    # Initial parking
    response = service.park_vehicle
    session = ParkingSession.find_by(vehicle_id: @vehicle_small.id, parking_slot_id: response.dig(:assigned_slot, :id))
    assert @small_slot.reload.occupied

    # Unpark the vehicle
    UnparkingService.new(session).unpark_vehicle
    refute @small_slot.reload.occupied

    # Vehicle return in less than an hour after unparking
    travel_to Time.now + 30.minutes do
      response = service.park_vehicle
      session = ParkingSession.find_by(vehicle_id: @vehicle_small.id, parking_slot_id: response.dig(:assigned_slot, :id))

      assert @small_slot.reload.occupied
      assert_equal @small_slot.id, session.parking_slot.id
      assert_equal response[:status_code], 201
    end
  end

  test 'should return an error message if no parking slots are available' do
    ParkingSlot.update_all(occupied: true)

    service = ParkingService.new(@entry_point, @vehicle_medium)
    slot = service.park_vehicle

    assert_equal 'No suitable slots available', slot[:message]
  end
end
