class ParkingService
  def initialize(entry_point, vehicle)
    @vehicle = vehicle
    @entry_point = entry_point
    @slot_finder = SlotFinder.new(@vehicle)
  end

  def park_vehicle
    recent_session = find_recent_session_with_exit_time

    suitable_slots = @slot_finder.find_suitable_slots
    return error_response('No suitable slots available', 404) if suitable_slots.empty?

    entry_point_slots = find_entry_point_slots(suitable_slots)
    return error_response('No suitable slots available', 404) if entry_point_slots.empty?

    if recent_session && within_one_hour?(recent_session.exit_time)
      assign_and_update_slot(entry_point_slots, recent_session)
    end

    assign_and_update_slot(entry_point_slots, nil)
  end

  def unpark_vehicle(session)
    exit_time = Time.now
    session.update(exit_time: exit_time)
    session.parking_slot.update(occupied: false)

    { vehicle:session.vehicle, parking_fee: FeeCalculator.calculate(session) }
  end

  private

  def find_recent_session_with_exit_time
    ParkingSession.where(vehicle: @vehicle).where.not(exit_time: nil).order(exit_time: :desc).first
  end

  def within_one_hour?(exit_time)
    exit_time && (Time.now - exit_time) <= 1.hour
  end

  def find_entry_point_slots(suitable_slots)
    entry_point_slots = @slot_finder.find_slots_near_entry(suitable_slots, @entry_point.id.to_s)
    entry_point_slots.empty? ? @slot_finder.find_slots_near_any_entry(suitable_slots) : entry_point_slots
  end

  def assign_and_update_slot(entry_point_slots, recent_session)
    assigned_slot = entry_point_slots.min_by { |slot| @slot_finder.distances_from_entry(slot)[@entry_point.id.to_s] || Float::INFINITY }

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
