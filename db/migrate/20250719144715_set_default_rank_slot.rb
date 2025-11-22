class SetDefaultRankSlot < ActiveRecord::Migration[8.0]
  def up
    RankSlot.create!(name: 'default')
  end

  def down
  end
end
