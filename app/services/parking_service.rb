class ParkingService
  FLAT_RATE = 40
  HOURLY_RATES = { 'sp' => 20, 'mp' => 60, 'lp' => 100 }
  DAILY_RATE = 5000

  def initialize(entry_point, vehicle)
    @entry_point = entry_point
    @vehicle = vehicle
  end

  def park_vehicle
    suitable_slots = ParkingSlot.where(occupied: false).select do |slot|
      slot_compatible?(slot, @vehicle.size)
    end

    filtered_slots = suitable_slots.select do |slot|
      distances = distances_from_entry(slot)
      distances.key?(@entry_point.id.to_s)
    end

    sorted_slots = filtered_slots.sort_by do |slot|
      distances = distances_from_entry(slot)
      distances[@entry_point.id.to_s]
    end

    assigned_slot = sorted_slots.first
    assigned_slot.update(occupied: true)

    ParkingSession.create(vehicle: @vehicle, parking_slot: assigned_slot, entry_time: Time.now)
    assigned_slot
  end

  def unpark_vehicle(session)
    exit_time = Time.now
    session.update(exit_time: exit_time)
    session.parking_slot.update(occupied: false)

    calculate_fees(session)
  end

  private

  def slot_compatible?(slot, vehicle_size)
    case vehicle_size
    when 'small'
      true
    when 'medium'
      slot.mp? || slot.lp?
    when 'large'
      slot.lp?
    else
      false
    end
  end

  def distances_from_entry(slot)
    JSON.parse(slot.distances)
  end

  def calculate_fees(session)
    duration = ((session.exit_time - session.entry_time) / 3600.0).ceil
    if duration > 24
      days = duration / 24
      remainder = duration % 24
      daily_charge = days * DAILY_RATE
      remainder_charge = calculate_remainder_charge(session.parking_slot.size, remainder)
      daily_charge + remainder_charge
    else
      calculate_remainder_charge(session.parking_slot.size, duration)
    end
  end

  def calculate_remainder_charge(slot_size, duration)
    if duration <= 3
      FLAT_RATE
    else
      FLAT_RATE + ((duration - 3) * HOURLY_RATES[slot_size])
    end
  end
end
