class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update destroy ]

  # GET /users or /users.json
  def index
    @list = User.not_deleted
  end

  # GET /users/new
  def new
    @rec = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @rec = User.new(user_params)

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

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @rec.update(user_params)
        format.html { redirect_to_index_with_success }
        format.json { render :show, status: :ok, location: @rec }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rec.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @rec.update!(deleted_at: Time.now)

    respond_to do |format|
      format.html { redirect_to users_path, status: :see_other, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

   # Use callbacks to share common setup or constraints between actions.
  def set_user
    @rec = User.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.expect(user: [:code, :admin])
  end
end
