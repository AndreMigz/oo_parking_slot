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
end
