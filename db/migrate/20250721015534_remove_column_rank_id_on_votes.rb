class RemoveColumnRankIdOnVotes < ActiveRecord::Migration[8.0]
  def change
    remove_belongs_to :votes, :rank,  null: false
  end
end
