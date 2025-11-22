class CreateStages < ActiveRecord::Migration[8.0]
  def change
    create_table :stages do |t|
      t.string    :name,        null: false
      t.string    :key,         null: false
      t.boolean   :available,   null: false,  default: false
      t.datetime  :deleted_at
      t.timestamps
    end
  end
end
