class RemoveColumnMatchIdOnVotes < ActiveRecord::Migration[8.0]
  def change
    remove_column :votes, :match_id,  :bigint,  null: false
  end
end
