require "test_helper"

class ParkingControllerTest < ActionDispatch::IntegrationTest

  setup do
    @vehicle = vehicles(:small_vehicle)
    @entry_point = entry_points(:two)

    @small_slot = ParkingSlot.create(name: 'B1', size: :sp, distances: { @entry_point.id.to_s => 1 }.to_json, occupied: false)
    @medium_slot = ParkingSlot.create(name: 'B2', size: :mp, distances: { @entry_point.id.to_s => 2 }.to_json, occupied: false)
    @large_slot = ParkingSlot.create(name: 'B3', size: :lp, distances: { @entry_point.id.to_s => 3 }.to_json, occupied: false)
  end

  test 'should be able to park a vehicle' do
    assert_difference('ParkingSession.count') do
      post park_path, params: {
        vehicle_id: @vehicle.id,
        entry_point_id: @entry_point.id
      }
    end

    assert @vehicle.reload.parking_sessions.last.parking_slot.occupied?
  end

  test 'should be able to unpark a vehicle' do
    # Park
    ParkingService.new(@entry_point, @vehicle).park_vehicle

    parking_session = @vehicle.reload.parking_sessions.last

    #Unpark
    post unpark_path, params: {
      session_id: parking_session.id
    }

    assert_not @vehicle.reload.parking_sessions.last.parking_slot.occupied?
  end

end
