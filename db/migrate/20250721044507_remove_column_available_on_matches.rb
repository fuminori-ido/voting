class RemoveColumnAvailableOnMatches < ActiveRecord::Migration[8.0]
  def change
    remove_column :matches,  :available, :boolean,  default: false, null: false
  end
end
