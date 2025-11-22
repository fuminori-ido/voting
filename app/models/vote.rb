class Vote < ApplicationRecord
  belongs_to  :user
  belongs_to  :match_candidate

  validates_uniqueness_of :match_candidate_id,  scope: [:user_id]
  validate :validate_stage_availability

  scope :score, -> {
    joins(match_candidate: [{match: :stage}, :candidate]).
    where('matches.deleted_at           IS NULL').
    where('stages.deleted_at            IS NULL').
    where('candidates.deleted_at        IS NULL').
    where('match_candidates.deleted_at  IS NULL').
    select('matches.name as m, candidates.name as c, sum(point) as score').
    group(:m, :c)
  }

  private

  def validate_stage_availability
    if !match_candidate&.match.stage.available
      errors.add(:base, :stage_is_not_available)
    end
  end
end
