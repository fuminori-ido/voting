class CreateRanks < ActiveRecord::Migration[8.0]
  def change
    create_table :ranks do |t|
      t.string      :name,      null: false
      t.integer     :weight,    null: false, default: 1

      t.datetime    :deleted_at
      t.timestamps
    end
  end
end
