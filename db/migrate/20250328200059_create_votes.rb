class CreateVotes < ActiveRecord::Migration[8.0]
  def change
    create_table :votes do |t|
      t.bigint      :match_id,            null: false
      t.bigint      :match_candidate_id,  null: false
      t.bigint      :user_id,             null: false

      t.timestamps
      t.index       [:match_id,           :user_id], unique: true
      t.index       [:match_candidate_id, :user_id], unique: true
    end
  end
end
