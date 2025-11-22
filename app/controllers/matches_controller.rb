class MatchesController < ApplicationController
  before_action :set_match, only: %i[ show edit update destroy ]

  # GET /matches or /matches.json
  def index
    @list = Match.not_deleted.joins(:event).order({events: {name: 'ASC'}}, :name)
  end

  # GET /matches/new
  def new
    @rec = Match.new
  end

  # show stat
  def show
  end

  # GET /matches/1/edit
  def edit
  end

  # POST /matches or /matches.json
  def create
    @rec = Match.new(allowed_params)

    respond_to do |format|
      if @rec.save
        format.html { redirect_to_index_with_success }
        format.json { render :show, status: :created, location: @rec }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @rec.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matches/1 or /matches/1.json
  def update
    respond_to do |format|
      if @rec.update(allowed_params)
        format.html { redirect_to_index_with_success }
        format.json { render :show, status: :ok, location: @rec }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rec.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1 or /matches/1.json
  def destroy
    @rec.update!(deleted_at: Time.now)

    respond_to do |format|
      format.html { redirect_to matches_path, status: :see_other, notice: "Match was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_match
    @rec = Match.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def allowed_params
    params.expect(match: [:event_id,  :stage_id,  :rank_slot_id, :name])
  end
end
