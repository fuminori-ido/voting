class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string      :name,    null: false
      t.belongs_to  :tenant,  null: false

      t.datetime    :deleted_at
      t.timestamps
    end
  end
end
