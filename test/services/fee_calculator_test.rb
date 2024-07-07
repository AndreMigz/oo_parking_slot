# test/services/fee_calculator_test.rb
require 'test_helper'

class FeeCalculatorTest < ActiveSupport::TestCase
  test 'calculate fee for session less than 3 hour' do
    session = parking_sessions(:less_than_1_hour)
    fee = FeeCalculator.calculate(session)
    assert_equal 40, fee
  end

  test 'calculate fee for session less than 24 hours' do
    session = parking_sessions(:less_than_24_hours)
    fee = FeeCalculator.calculate(session)
    assert_equal 2040, fee  # Flat rate (40) + hourly rate (10 hours * 10 per hour)
  end

  test 'calculate fee for session more than 24 hours' do
    session = parking_sessions(:more_than_24_hours)
    fee = FeeCalculator.calculate(session)
    assert_equal 10000 + 100, fee  # Daily rate (2 days * 5000 per day ) + hourly rate
  end
end
