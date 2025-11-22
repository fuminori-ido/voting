class AddColumnPointOnVotes < ActiveRecord::Migration[8.0]
  def change
    add_column :votes, :point,  :integer, null: false, default: 0
  end
end
