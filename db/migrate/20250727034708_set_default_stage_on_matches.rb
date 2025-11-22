class SetDefaultStageOnMatches < ActiveRecord::Migration[8.0]
  def up
    default_stage = Stage.not_deleted.first
    Match.update_all(stage_id: default_stage.id)
  end

  def down
  end
end
