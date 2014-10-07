class TimesheetsController < ApplicationController
  before_action :set_timesheet, only: [:show, :edit, :update, :destroy]

  def check_if_current_user
    if defined?(current_user.id)
      @url_user = User.find(params[:user_id])
      if current_user.id != @url_user.id
        redirect_to user_timesheets_path(current_user.id)
      end
    else
        redirect_to new_user_session_path
    end
  end
    
  # GET /timesheets
  def index
    check_if_current_user
    @url_user = User.find(params[:user_id])
    @timesheets = Timesheet.where({:user_id => @url_user.id})
  end

  # GET /timesheets/1
  def show
    check_if_current_user
    @url_user = User.find(params[:user_id])
  end

  # GET /timesheets/new
  def new
    check_if_current_user
    @url_user = User.find(params[:user_id])
    @projects = Project.all
    @timesheet = Timesheet.new
  end

  # GET /timesheets/1/edit
  def edit
    check_if_current_user
    @url_user = User.find(params[:user_id])
    @projects = Project.all
  end

  # POST /timesheets
  def create
    check_if_current_user
    @projects = Project.all
    @url_user = User.find(params[:user_id])
    @timesheet = Timesheet.new(timesheet_params)
    @current_time = Time.now
    if @timesheet.timeout > @current_time then
        @timesheet.errors.add(:timeout, "cannot be for a future time.")
    end

    @timesheet.hours = ((@timesheet.timeout - @timesheet.timein).to_d / 3600)
    @timesheet.user_id = @url_user.id
    @timesheet.payrate = @url_user.payrate

    if @timesheet.save
        redirect_to user_timesheets_path(@url_user), notice: 'Timesheet was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /timesheets/1
  def update
    check_if_current_user
    @projects = Project.all
    @url_user = User.find(params[:user_id])
    timesheet = Timesheet.new(timesheet_params)
    @timesheet.hours = ((timesheet.timeout - timesheet.timein).to_d / 3600)
    @timesheet.user_id = @url_user.id
    @timesheet.payrate = @url_user.payrate
    if @timesheet.update(timesheet_params)
      redirect_to user_timesheets_path(@url_user), notice: 'Timesheet was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /timesheets/1
  def destroy
    check_if_current_user
    @url_user = User.find(params[:user_id])
    @timesheet.destroy
    redirect_to user_timesheets_url, notice: 'Timesheet was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_timesheet
      @timesheet = Timesheet.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def timesheet_params
        params.require(:timesheet).permit(:date, :timein, :timeout, :description, :project)
    end
end
