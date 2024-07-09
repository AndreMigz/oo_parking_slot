class SlotFinder
  def initialize(vehicle, entry_point)
    @vehicle = vehicle
    @entry_point = entry_point
  end

  def find_suitable_slot
    suitable_slots = ParkingSlot.where(occupied: false).select { |slot| slot_compatible?(slot, @vehicle.size) }
    sorted_suitable_slot = suitable_slots.sort_by { |slot| [slot_size_rank(slot.size), distances_from_entry(slot)[@entry_point.id.to_s] || Float::INFINITY] }

    suitable_slot = sorted_suitable_slot.first
  end

  private

  def distances_from_entry(slot)
    JSON.parse(slot.distances)
  end

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

  def slot_size_rank(size)
    case size
    when 'sp'
      1
    when 'mp'
      2
    when 'lp'
      3
    end
  end
end
