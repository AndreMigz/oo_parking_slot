require "test_helper"

class EntryPointTest < ActiveSupport::TestCase
  setup do
    @entry_point = EntryPoint.new(name: 'D')
  end

  test 'should be valid' do
    assert @entry_point.valid?
  end

  test 'name should be present' do
    @entry_point.name = nil
    assert_not @entry_point.valid?
  end

  test 'name should be unique' do
    # Create first record
    @entry_point.save
    assert EntryPoint.find_by(name: @entry_point.name).present?

    # Save a new record with the same entry point name
    assert_no_difference('EntryPoint.count') do
      EntryPoint.create(name: @entry_point.name)
    end
  end
end
