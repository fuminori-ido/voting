class MovePointToVotes < ActiveRecord::Migration[8.0]
  def change
    Vote.find_each do |v|
      v.update_column(:point, v.rank.weight)
    end
  end
end
