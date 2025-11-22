class MatchCandidate < ApplicationRecord
  belongs_to  :match
  belongs_to  :candidate
  has_many    :votes
end
