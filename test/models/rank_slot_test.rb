require "test_helper"

class RankSlotTest < ActiveSupport::TestCase
  context 'assoc' do
    setup do
      @slot = rank_slots(:soft)
    end

    context 'ranks' do
      should 'not include deleted' do
        assert  @slot.ranks.exists?(ranks(:rank_1).id)
        assert !@slot.ranks.exists?(ranks(:deleted).id)
      end
    end

    context 'matches' do
      should 'not include deleted' do
        assert  @slot.matches.exists?(matches(:fest_2025_1_a).id)
        assert !@slot.matches.exists?(matches(:deleted).id)
      end
    end
  end
end
