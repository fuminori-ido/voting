class AddColumnRankSlotIdOnMatches < ActiveRecord::Migration[8.0]
  def change
    add_column :matches,  :rank_slot_id, :bigint
  end
end
