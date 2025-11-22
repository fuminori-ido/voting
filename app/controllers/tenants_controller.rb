class TenantsController < ApplicationController
  before_action :set_tenant, only: %i[edit update destroy ]

  # GET /tenants or /tenants.json
  def index
    @list = Tenant.not_deleted.order(:name)
  end

  # GET /tenants/new
  def new
    @rec = Tenant.new
  end

  # GET /tenants/1/edit
  def edit
  end

  # POST /tenants or /tenants.json
  def create
    @rec = Tenant.new(allowed_params)

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

  # PATCH/PUT /tenants/1 or /tenants/1.json
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

  # DELETE /tenants/1 or /tenants/1.json
  def destroy
    @rec.update!(deleted_at: Time.now)

    respond_to do |format|
      format.html { redirect_to tenants_path, status: :see_other, notice: "Tenant was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tenant
    @rec = Tenant.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def allowed_params
    params.expect(tenant: [:name])
  end
end
