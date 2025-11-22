class SetDefaultRankSlotOnMatches < ActiveRecord::Migration[8.0]
  def up
    default_rank_slot = RankSlot.not_deleted.first
    Match.update_all(rank_slot_id: default_rank_slot.id)
  end

  def down
  end
end
