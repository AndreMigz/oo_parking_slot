class ParkingService
  def initialize(entry_point, vehicle)
    @vehicle = vehicle
    @entry_point = entry_point
    @slot_finder = SlotFinder.new(@vehicle, @entry_point)
  end

  def park_vehicle
    recent_session = find_recent_session_with_exit_time

    suitable_slot = @slot_finder.find_suitable_slot
    return error_response('No suitable slots available', 404) unless suitable_slot.present?

    if recent_session && within_one_hour?(recent_session.exit_time)
      return assign_and_update_slot(suitable_slot, recent_session)
    end

    assign_and_update_slot(suitable_slot, nil)
  end

  private

  def find_recent_session_with_exit_time
    ParkingSession.where(vehicle: @vehicle).where.not(exit_time: nil).order(exit_time: :desc).first
  end

  def within_one_hour?(exit_time)
    exit_time && (Time.now - exit_time) <= 1.hour
  end

  def assign_and_update_slot(assigned_slot, recent_session)
    if recent_session.nil?
      parking_session = ParkingSession.create(vehicle: @vehicle, parking_slot: assigned_slot, entry_time: Time.now)
    else
      recent_session.update(parking_slot: assigned_slot, exit_time: nil)
      parking_session = recent_session
    end

    assigned_slot.update(occupied: true)
    success_response(parking_session, assigned_slot, 201)
  end

  def success_response(parking_session, assigned_slot, status)
    {
      status: 'success',
      status_code: status,
      parking_session: {
        id: parking_session.id,
        vehicle_id: parking_session.vehicle.id,
        parking_slot_id: parking_session.parking_slot.id,
        entry_time: parking_session.entry_time
      },
      assigned_slot: {
        id: assigned_slot.id,
        name: assigned_slot.name,
        occupied: assigned_slot.occupied
      }
    }
  end

  def error_response(message, status)
    { status: 'error', status_code: status, message: message }
  end
end
