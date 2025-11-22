class Match < ApplicationRecord
  belongs_to  :event
  belongs_to  :rank_slot
  belongs_to  :stage
  has_many    :match_candidates,  -> { not_deleted.joins(:candidate).
                                          where('candidates.deleted_at IS NULL') }

  validates_presence_of   :name
  validates_uniqueness_of :name
end
