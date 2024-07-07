class FeeCalculator
  FLAT_RATE = 40
  HOURLY_RATES = { 'sp' => 20, 'mp' => 60, 'lp' => 100 }
  DAILY_RATE = 5000

  def self.calculate(session)
    duration = ((session.exit_time - session.entry_time) / 3600.0).ceil
    if duration > 24
      days = duration / 24
      remainder = duration % 24
      daily_charge = days * DAILY_RATE
      remainder_charge = calculate_remainder_charge(session.parking_slot.size, remainder)
      daily_charge + remainder_charge
    else
      if duration <= 3
        FLAT_RATE
      else
        FLAT_RATE + calculate_remainder_charge(session.parking_slot.size, duration - 3)
      end
    end
  end

  def self.calculate_remainder_charge(slot_size, duration)
    ((duration) * HOURLY_RATES[slot_size])
  end
end
