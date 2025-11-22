require "test_helper"

class MatchTest < ActiveSupport::TestCase
  context 'match_candidates assoc' do
    should 'not contain deleted candidate' do
      match = matches(:fest_2025_1_a)
      mc    = match_candidates(:fest_2025_1_a_deleted)
      assert mc.candidate.deleted?
      assert match.match_candidates.where(id: mc.id).empty?
    end
  end
end
