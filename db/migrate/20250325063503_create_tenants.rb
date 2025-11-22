class CreateTenants < ActiveRecord::Migration[8.0]
  def change
    create_table :tenants do |t|
      t.string    :name,    null: false

      t.datetime  :deleted_at
      t.timestamps
    end
  end
end
