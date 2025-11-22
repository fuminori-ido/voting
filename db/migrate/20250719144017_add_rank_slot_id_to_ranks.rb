class AddRankSlotIdToRanks < ActiveRecord::Migration[8.0]
  def change
    add_column :ranks,  :rank_slot_id, :bigint
  end
end
