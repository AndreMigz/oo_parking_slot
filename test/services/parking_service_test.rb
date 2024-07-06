require 'test_helper'

class ParkingServiceTest < ActiveSupport::TestCase
  setup do
    @entry_point = entry_points(:one)
    @vehicle_small = vehicles(:one)
    @vehicle_medium = vehicles(:two)
    @vehicle_large = vehicles(:three)

    @small_slot = ParkingSlot.create(size: :sp, distances: { @entry_point.id.to_s => 1 }.to_json, occupied: false)
    @medium_slot = ParkingSlot.create(size: :mp, distances: { @entry_point.id.to_s => 2 }.to_json, occupied: false)
    @large_slot = ParkingSlot.create(size: :lp, distances: { @entry_point.id.to_s => 3 }.to_json, occupied: false)
  end

  test "park small vehicle in SP slot" do
    service = ParkingService.new(@entry_point, @vehicle_small)
    slot = service.park_vehicle

    assert_equal @small_slot, slot
    assert @small_slot.reload.occupied
  end

  test "park medium vehicle in MP slot" do
    service = ParkingService.new(@entry_point, @vehicle_medium)
    slot = service.park_vehicle

    assert_equal @medium_slot, slot
    assert @medium_slot.reload.occupied
  end

  test "park large vehicle in LP slot" do
    service = ParkingService.new(@entry_point, @vehicle_large)
    slot = service.park_vehicle

    assert_equal @large_slot, slot
    assert @large_slot.reload.occupied
  end

  test "unpark vehicle and calculate fee" do
    service = ParkingService.new(@entry_point, @vehicle_small)
    slot = service.park_vehicle
    session = ParkingSession.find_by(vehicle: @vehicle_small, parking_slot: slot)

    travel_to Time.now + 5.hours do
      fee = service.unpark_vehicle(session)
      assert_equal 80, fee  # 40 for the first 3 hours, 2*20 for the next 2 hours
      refute @small_slot.reload.occupied
    end
  end

  test "unpark vehicle and calculate fee for 24 hours" do
    service = ParkingService.new(@entry_point, @vehicle_small)
    slot = service.park_vehicle
    session = ParkingSession.find_by(vehicle: @vehicle_small, parking_slot: slot)

    travel_to Time.now + 29.hours do
      fee = service.unpark_vehicle(session)
      assert_equal 5080, fee  # 5000 for 24 hours, 40 for the first 3 hours, 2*20 for the next 2 hours
      refute @small_slot.reload.occupied
    end
  end
end
