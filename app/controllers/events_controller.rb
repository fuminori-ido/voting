class EventsController < ApplicationController
  before_action :set_event,   only: %i[edit update destroy ]

  # GET /events or /events.json
  def index
    @list = Event.not_deleted.order(:name)
  end

  # GET /events/new
  def new
    @rec = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @rec = Event.new(allowed_params.merge(tenant_id: Tenant.first.id))

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

  # PATCH/PUT /events/1 or /events/1.json
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

  # DELETE /events/1 or /events/1.json
  def destroy
    @rec.update!(deleted_at: Time.now)

    respond_to do |format|
      format.html { redirect_to events_path, status: :see_other, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @rec = Event.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def allowed_params
    params.expect(event: [:name])
  end
end
