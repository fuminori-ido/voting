class StagesController < ApplicationController
  before_action :set_stage, only: %i[ show edit update destroy show_vote qr ]

  # GET /stages
  def index
    @list = Stage.not_deleted.order(:name)
  end

  # GET /stages/1
  def show
  end

  # GET /stages/new
  def new
    @rec = Stage.new
  end

  # GET /stages/1/edit
  def edit
  end

  # POST /stages
  def create
    @rec = Stage.new(allowed_params)

    respond_to do |format|
      if @rec.save
        format.html { redirect_to_index_with_success }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stages/1
  def update
    respond_to do |format|
      if @rec.update(allowed_params)
        format.html { redirect_to_index_with_success }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stages/1
  def destroy
    @rec.update!(deleted_at: Time.now)

    respond_to do |format|
      format.html { redirect_to stages_path, status: :see_other, notice: "Stage was successfully destroyed." }
    end
  end

  # GET /stages/1/show_vote;  show vote page URL
  def show_vote
    render layout:  'show_vote'
  end

  # GET /stages/1/qr    ; send QR image
  def qr
    qrcode = RQRCode::QRCode.new(new_vote_url(key: @rec.key))
    send_data(qrcode.as_svg(color:            '000',
                            shape_rendering:  'crispEdges',
                            module_size:      11,
                            standalone:       true,
                            use_path:         true).html_safe,
              type:         'image/svg',
              disposition:  'inline')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_stage
    @rec = Stage.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def allowed_params
    params.expect(stage: [:name, :key, :available])
  end
end
