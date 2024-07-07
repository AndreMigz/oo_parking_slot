require "test_helper"

class ParkingControllerTest < ActionDispatch::IntegrationTest

  setup do
    @vehicle = vehicles(:one)
    @entry_points = EntryPoint.create([{ name: 'A' }, { name: 'B' }, { name: 'C' }])


    @entry_points.each do |entry_point|
      ParkingSlot.create(size: :sp, distances: { entry_point.id.to_s => 1 }.to_json, occupied: false)
      ParkingSlot.create(size: :mp, distances: { entry_point.id.to_s => 2 }.to_json, occupied: false)
      ParkingSlot.create(size: :lp, distances: { entry_point.id.to_s => 3 }.to_json, occupied: false)
    end
  end

  test 'should be able to park a vehicle' do
    assert_difference('ParkingSession.count') do
      post park_path, params: {
        vehicle_id: @vehicle.id,
        entry_point_id: @entry_points.first.id
      }
    end

    assert @vehicle.reload.parking_sessions.last.parking_slot.occupied?
  end

  test 'should be able to unpark a vehicle' do
    # Park
    ParkingService.new(@entry_points.first, @vehicle).park_vehicle

    parking_session = @vehicle.reload.parking_sessions.last

    #Unpark
    post unpark_path, params: {
      session_id: parking_session.id
    }

    assert_not @vehicle.reload.parking_sessions.last.parking_slot.occupied?
  end

end
