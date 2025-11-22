class AddIndexKeyOnStages < ActiveRecord::Migration[8.0]
  def change
    add_index :stages, :key, unique: true
  end
end
