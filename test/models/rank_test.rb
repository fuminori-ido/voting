require "test_helper"

class RankTest < ActiveSupport::TestCase
  setup do
    @soft_rank_1 = ranks(:rank_1)
  end

  context 'validation' do
    context 'name uniqueness' do
      should 'work under rank_slot scope' do
        assert_invalid_record(Rank.new(
            rank_slot:  @soft_rank_1.rank_slot,
            name:       @soft_rank_1.name))
        assert_valid_record(Rank.new(
            rank_slot:  rank_slots(:hard),
            name:       @soft_rank_1.name))
      end
    end
  end
end
