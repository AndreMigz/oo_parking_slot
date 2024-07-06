require "test_helper"

class VehicleTest < ActiveSupport::TestCase
  setup do
    @vehicle = Vehicle.new(size: :small)
  end

  test 'should be valid' do
    assert @vehicle.valid?
  end

  test 'size should be present' do
    @vehicle.size = nil
    assert_not @vehicle.valid?
  end

  test 'should have correct enum values' do
    assert_equal 0, Vehicle.sizes[:small]
    assert_equal 1, Vehicle.sizes[:medium]
    assert_equal 2, Vehicle.sizes[:large]
  end

  test 'should have many parking sessions' do
    assert_respond_to @vehicle, :parking_sessions
  end
end
