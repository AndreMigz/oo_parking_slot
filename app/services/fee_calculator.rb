class FeeCalculator
  FLAT_RATE = 40.freeze
  HOURLY_RATES = { 'sp' => 20, 'mp' => 60, 'lp' => 100 }.freeze
  DAILY_RATE = 5000.freeze
  HOURS_IN_A_DAY = 24.freeze
  FLAT_RATE_DURATION = 3.freeze

  def self.calculate(session)
    duration = ((session.exit_time - session.entry_time) / 3600.0).ceil
    if duration > HOURS_IN_A_DAY
      days = duration / HOURS_IN_A_DAY
      remainder = duration % HOURS_IN_A_DAY
      daily_charge = days * DAILY_RATE
      remainder_charge = calculate_remainder_charge(session.parking_slot.size, remainder)
      daily_charge + remainder_charge
    else
      if duration <= FLAT_RATE_DURATION
        FLAT_RATE
      else
        FLAT_RATE + calculate_remainder_charge(session.parking_slot.size, duration - FLAT_RATE_DURATION)
      end
    end
  end

  def self.calculate_remainder_charge(slot_size, duration)
    (duration * HOURLY_RATES[slot_size])
  end
end
