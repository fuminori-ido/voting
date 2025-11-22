class RanksController < ApplicationController
  before_action :set_rank, only: %i[ show edit update destroy ]

  # GET /ranks or /ranks.json
  def index
    @list = Rank.not_deleted.joins(:rank_slot).
                order(rank_slot:  {name:   'ASC'},
                      weight:     'DESC')
  end

  # GET /ranks/1 or /ranks/1.json
  def show
  end

  # GET /ranks/new
  def new
    @rec = Rank.new
  end

  # GET /ranks/1/edit
  def edit
  end

  # POST /ranks or /ranks.json
  def create
    @rec = Rank.new(allowed_params)

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

  # PATCH/PUT /ranks/1 or /ranks/1.json
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

  # DELETE /ranks/1 or /ranks/1.json
  def destroy
    @rec.update!(deleted_at: Time.now)

    respond_to do |format|
      format.html { redirect_to ranks_path, status: :see_other, notice: "Rank was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rank
    @rec = Rank.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def allowed_params
    params.expect(rank: [:rank_slot_id, :name, :weight])
  end
end
