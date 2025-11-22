require 'securerandom'

class VotesController < ApplicationController
  before_action :set_stage, only: %w{new create}

  # GET /votes/new
  def new
    return if performed?

    render layout: 'vote'
  end

  # POST /votes or /votes.json
  def create
    return if performed?

    respond_to do |format|
      begin
        vote = nil
        Vote.transaction do
          params[:votes].permit!
          for match_id, votes_per_match in params[:votes] do
            for rank_id, mc_id in votes_per_match do
              rank = Rank.not_deleted.find_by_id(rank_id)
              next if rank.blank?

              vote = Vote.create_or_find_by!(
                      user_id:              current_user.id,
                      match_candidate_id:   mc_id,
                      point:                rank.weight)
            end
          end
        end
        format.html { redirect_to voted_votes_path, notice: v_i18n('voted') }
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error(e.message)
        if vote && vote.errors.exists?
          Rails.logger.error 'vote: ' + vote.errors.full_messages.join(' & ')
        end
        format.html { redirect_to voted_votes_path, alert: e.message }
      end
    end
  end

  def voted
    render layout: 'vote'
  end

  private

  def set_stage
    @stage  = Stage.not_deleted.find_by_key(params[:key])
    if !(@stage && @stage.available?)
      render_404
    end
  end

  # Only allow a list of trusted parameters through.
  def allowed_params
    params.permit(:votes)
  end

  def render_404
    render  file:   "#{Rails.root}/public/404.html",
            layout: false, 
            status: 404
  end
end
