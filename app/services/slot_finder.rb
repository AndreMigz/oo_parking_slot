class SlotFinder
  def initialize(vehicle)
    @vehicle = vehicle
  end

  def find_suitable_slots
    ParkingSlot.where(occupied: false).select { |slot| slot_compatible?(slot, @vehicle.size) }
  end

  def find_slots_near_entry(suitable_slots, entry_point_id)
    suitable_slots.select { |slot| distances_from_entry(slot).key?(entry_point_id) }
  end

  def find_slots_near_any_entry(suitable_slots)
    entry_point_ids = EntryPoint.all.pluck(:id).map(&:to_s)
    suitable_slots.select { |slot| entry_point_ids.any? { |entry_point_id| distances_from_entry(slot).key?(entry_point_id) } }
  end

  def distances_from_entry(slot)
    JSON.parse(slot.distances)
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
end
