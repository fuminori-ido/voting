require "test_helper"

class StageTest < ActiveSupport::TestCase
  context 'key' do
    should 'be set' do
      s = Stage.create!(name: 'stage')
      assert_not_nil s.key
    end
  end


  context 'validation' do
    context 'name uniqueness' do
      should 'work' do
        assert_invalid_record(Stage.new(
            name:       stages(:stage_a).name))
        assert_valid_record(Stage.new(
            name:       'new stage'))
      end
    end

    context 'key uniqueness' do
      should 'work' do
        assert_invalid_record(Stage.new(
            name:       'new stage',
            key:        stages(:stage_a).key))
        assert_valid_record(Stage.new(
            name:       'new stage',
            key:        'new key'))
      end
    end
  end
end
