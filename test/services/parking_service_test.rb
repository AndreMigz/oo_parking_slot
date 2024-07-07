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
    service = ParkingService.new(@entry_point, @vehicle_small)
    slot = service.park_vehicle

    assert @small_slot.reload.occupied
  end

  test "park medium vehicle in MP slot" do
    service = ParkingService.new(@entry_point, @vehicle_medium)
    slot = service.park_vehicle

    assert @medium_slot.reload.occupied
  end

  test "park large vehicle in LP slot" do
    service = ParkingService.new(@entry_point, @vehicle_large)
    slot = service.park_vehicle

    assert @large_slot.reload.occupied
  end

  test "unpark vehicle and calculate fee" do
    service = ParkingService.new(@entry_point, @vehicle_small)
    response = service.park_vehicle
    session = ParkingSession.find_by(vehicle_id: @vehicle_small.id, parking_slot_id: response.dig(:assigned_slot, :id))

    travel_to Time.now + 5.hours do
      fee = service.unpark_vehicle(session)
      assert_equal 80, fee.dig(:parking_fee)  # 40 for the first 3 hours, 2*20 for the next 2 hours
      refute @small_slot.reload.occupied
    end
  end

  test "unpark vehicle and calculate fee for 24 hours" do
    service = ParkingService.new(@entry_point, @vehicle_small)
    response = service.park_vehicle
    session = ParkingSession.find_by(vehicle: @vehicle_small, parking_slot: response.dig(:assigned_slot, :id))

    travel_to Time.now + 29.hours do
      fee = service.unpark_vehicle(session)
      assert_equal 5100, fee.dig(:parking_fee)  # 5000 for 24 hours, 40 for the first 3 hours, 5*20 for the next 5 hours
      refute @small_slot.reload.occupied
    end
  end

  test "vehicle returns within an hour" do
    service = ParkingService.new(@entry_point, @vehicle_small)

    # Initial parking
    response = service.park_vehicle
    session = ParkingSession.find_by(vehicle_id: @vehicle_small.id, parking_slot_id: response.dig(:assigned_slot, :id))
    assert @small_slot.reload.occupied

    # Unpark the vehicle
    service.unpark_vehicle(session)
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
end
