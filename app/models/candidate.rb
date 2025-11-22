class Candidate < ApplicationRecord
  mount_uploader :avatar, AvatarUploader

  has_many    :match_candidates,  -> { not_deleted }

  validates_presence_of   :name
  validates_uniqueness_of :name
end
