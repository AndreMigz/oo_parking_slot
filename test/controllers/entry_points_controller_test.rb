require "test_helper"

class EntryPointsControllerTest < ActionDispatch::IntegrationTest

  test 'should be able to fetch data from index route' do
    get entry_points_path
    assert_response :success
  end

  test 'should be able to create entry points using the create route' do
    assert_difference('EntryPoint.count') do
      post entry_points_path, params:
      {
        entry_point:
        {
          name: 'Test Entry Point'
        }
      }
    end

    assert_response :created
  end
end
