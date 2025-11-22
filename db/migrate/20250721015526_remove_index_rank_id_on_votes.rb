class RemoveIndexRankIdOnVotes < ActiveRecord::Migration[8.0]
  def change
    remove_index :votes,  :rank_id
  end
end
