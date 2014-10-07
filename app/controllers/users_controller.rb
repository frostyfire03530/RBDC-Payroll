class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def admin_check
    if defined?(current_user.id)
      if current_user.role != 'admin'
        redirect_to user_timesheets_path(current_user.id), notice: 'You do not have access to this resource.'
      end
    else
      redirect_to new_user_session_path
    end
  end

  def initial_check
    if defined?(current_user.id)
      if current_user.role != 'admin'
        @url_user = User.find(params[:id])
        if current_user.id != @url_user.id
          redirect_to user_timesheets_path(current_user.id), notice: 'You do not have access to this resource.'
        end
      end
    else
      redirect_to new_user_session_path
    end
  end

  # GET /users
  def index
    admin_check
    @users = User.all
  end

  # GET /users/1
  def show
    initial_check
  end

  # GET /users/new
  def new
    admin_check
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    initial_check
  end

  # POST /users
  def create
    admin_check
    @user = User.new(user_params)
    @user.encrypted_password = User.new(password: user_params['password']).encrypted_password

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    initial_check
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    initial_check
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :payrate, :active, :role)
    end
end
