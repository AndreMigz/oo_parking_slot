require "test_helper"

class VehiclesControllerTest < ActionDispatch::IntegrationTest

  test 'should be able to fetch vehicle list from index route' do
    get vehicles_path
    assert_response :success
    assert_includes(response.body, "vehicles")
  end

  test 'should be able to create vehicle using the create route' do
    assert_difference('Vehicle.count') do
      post vehicles_path, params:
      {
        vehicle:
        {
          size: 'small'
        }
      }
    end

    assert_response :created
  end

  test 'should not be able to create vehicle if params value are missing' do
    assert_no_difference('Vehicle.count') do
      post vehicles_path, params:
      {
        vehicle:
        {
          size: ''
        }
      }
    end

    assert_response :unprocessable_entity
  end
end
