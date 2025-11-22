class CreateMatches < ActiveRecord::Migration[8.0]
  def change
    create_table :matches do |t|
      t.string      :name,      null: false
      t.belongs_to  :event,     null: false
      t.boolean     :available, null: false,  default: false  # to vote

      t.datetime    :deleted_at
      t.timestamps
    end
  end
end
