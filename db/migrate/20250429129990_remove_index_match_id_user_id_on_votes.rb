class RemoveIndexMatchIdUserIdOnVotes < ActiveRecord::Migration[8.0]
  def change
    remove_index :votes,  column: [:match_id, :user_id],  unique: true
  end
end
