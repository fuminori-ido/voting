class Rank < ApplicationRecord
  validates_presence_of   :name
  validates_uniqueness_of :name,  conditions: ->{ where('deleted_at IS NULL') },
                                  scope:       :rank_slot_id

  belongs_to  :rank_slot
  has_many  :votes
end
