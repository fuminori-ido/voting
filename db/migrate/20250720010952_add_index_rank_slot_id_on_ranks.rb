class AddIndexRankSlotIdOnRanks < ActiveRecord::Migration[8.0]
  def change
    add_index :ranks, :rank_slot_id
  end
end
