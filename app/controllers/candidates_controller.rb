class CandidatesController < ApplicationController
  before_action :set_candidate, only: %i[edit update destroy thumb big_thumb]

  # GET /candidates or /candidates.json
  def index
    @list = Candidate.not_deleted.order(:name)
  end

  # GET /candidates/new
  def new
    @rec = Candidate.new
  end

  # GET /candidates/1/edit
  def edit
  end

  # POST /candidates or /candidates.json
  def create
    @rec = Candidate.new(allowed_params)

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

  # PATCH/PUT /candidates/1 or /candidates/1.json
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

  # DELETE /candidates/1 or /candidates/1.json
  def destroy
    @rec.update!(deleted_at: Time.now)

    respond_to do |format|
      format.html { redirect_to candidates_path, status: :see_other, notice: "Candidate was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def thumb
    send_file(@rec.avatar.thumb.path,
              filename:     @rec.avatar.thumb.identifier,
              disposition:  'inline')
  end

  def big_thumb
    send_file(@rec.avatar.bigger_thumb.path,
              filename:     @rec.avatar.bigger_thumb.identifier,
              disposition:  'inline')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_candidate
    @rec = Candidate.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def allowed_params
    params.expect(candidate: [:name, :avatar])
  end
end
