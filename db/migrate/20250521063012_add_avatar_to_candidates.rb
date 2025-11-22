class AddAvatarToCandidates < ActiveRecord::Migration[8.0]
  def change
    add_column :candidates, :avatar, :string
  end
end
