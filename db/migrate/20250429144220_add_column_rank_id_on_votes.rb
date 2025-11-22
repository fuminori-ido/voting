class AddColumnRankIdOnVotes < ActiveRecord::Migration[8.0]
  def change
    add_belongs_to  :votes, :rank,  null: false
  end
end
