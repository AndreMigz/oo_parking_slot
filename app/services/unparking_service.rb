class UnparkingService
  def initialize(session)
    @session = session
  end

  def unpark_vehicle
    exit_time = Time.now
    @session.update(exit_time: exit_time)
    @session.parking_slot.update(occupied: false)

    { vehicle:@session.vehicle, parking_fee: FeeCalculator.calculate(@session) }
  end
end
