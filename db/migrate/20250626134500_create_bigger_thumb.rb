class CreateBiggerThumb < ActiveRecord::Migration[8.0]
  def up
    Candidate.find_each do |c|
      c.avatar.recreate_versions!
    end
  end

  def down
  end
end
