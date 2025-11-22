class CreateMatchCandidates < ActiveRecord::Migration[8.0]
  def change
    create_table :match_candidates do |t|
      t.belongs_to  :match,       null: false
      t.belongs_to  :candidate,   null: false

      t.datetime    :deleted_at
      t.timestamps
    end
  end
end
