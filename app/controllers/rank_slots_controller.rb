class RankSlotsController < ApplicationController
  before_action :set_rank_slot, only: %i[ show edit update destroy ]

  # GET /rank_slots
  def index
    @list = RankSlot.not_deleted.order(:name)
  end

  # GET /rank_slots/new
  def new
    @rec = RankSlot.new
  end

  # GET /ranks/1 or /ranks/1.json
  def show
  end

  # GET /rank_slots/1/edit
  def edit
  end

  # POST /rank_slots
  def create
    @rec = RankSlot.new(allowed_params)

    respond_to do |format|
      if @rec.save
        format.html { redirect_to_index_with_success }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rank_slots/1
  def update
    respond_to do |format|
      if @rec.update(allowed_params)
        format.html { redirect_to_index_with_success }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rank_slots/1
  def destroy
    @rec.update!(deleted_at: Time.now)

    respond_to do |format|
      format.html { redirect_to rank_slots_path, status: :see_other, notice: "Rank slot was successfully destroyed." }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rank_slot
    @rec = RankSlot.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def allowed_params
    params.expect(rank_slot: [:name])
  end
end
