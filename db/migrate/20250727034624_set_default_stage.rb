class SetDefaultStage < ActiveRecord::Migration[8.0]
  def change
    Stage.create!(name: 'default')
  end
end
