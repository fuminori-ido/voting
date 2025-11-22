# Stage is a group of matches which allow user to vote on multiple matches
# at the same time.
class Stage < ApplicationRecord
  has_many  :matches,       -> { not_deleted }

  before_validation :set_uniq_key

  validates_presence_of   :name
  validates_uniqueness_of :name
  validates_uniqueness_of :key

  private

  def set_uniq_key
    if self.key.blank?
      # set 64byte length [0-9a-z] random string
      x = ''
      64.times{ x += rand(36).to_s(36)}
      self.key  = x
    end
  end
end
