require 'test_helper'

class UnparkingServiceTest < ActiveSupport::TestCase
  setup do
    @entry_point = entry_points(:two)
    @vehicle_small = Vehicle.create(size: :small)

    @small_slot = ParkingSlot.create(name: 'B1', size: :sp, distances: { @entry_point.id.to_s => 1 }.to_json, occupied: false)
    @medium_slot = ParkingSlot.create(name: 'B2', size: :mp, distances: { @entry_point.id.to_s => 2 }.to_json, occupied: false)
    @large_slot = ParkingSlot.create(name: 'B3', size: :lp, distances: { @entry_point.id.to_s => 3 }.to_json, occupied: false)

    response = ParkingService.new(@entry_point, @vehicle_small).park_vehicle
    @session = ParkingSession.find_by(vehicle_id: @vehicle_small.id, parking_slot_id: response.dig(:assigned_slot, :id))
  end

  test "unpark vehicle and calculate fee" do
    travel_to Time.now + 5.hours do
      fee = UnparkingService.new(@session).unpark_vehicle
      assert_equal 80, fee.dig(:parking_fee)  # 40 for the first 3 hours, 2*20 for the next 2 hours
      refute @small_slot.reload.occupied
    end
  end

  test "unpark vehicle and calculate fee for 24 hours" do

    travel_to Time.now + 29.hours do
      fee = UnparkingService.new(@session).unpark_vehicle
      assert_equal 5100, fee.dig(:parking_fee)  # 5000 for 24 hours, 40 for the first 3 hours, 5*20 for the next 5 hours
      refute @small_slot.reload.occupied
    end
  end

end
