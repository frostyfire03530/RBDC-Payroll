class TimesheetsController < ApplicationController
  before_action :set_timesheet, only: [:show, :edit, :update, :destroy]
    
  def pay_period_date
    @period_date = ""
    current_date = Date.today
    @is_first_part_of_month = false
    if current_date.strftime("%d").to_i <= 15
      @is_first_part_of_month = true
    end
    if @is_first_part_of_month
      @period_date = current_date.strftime("%m/01/%Y to %m/15/%Y")
    else
      holding_date = Date.today.end_of_month
      @period_date = holding_date.strftime("%m/16/%Y to %m/%d/%Y")
    end
  end
    
  def is_first_part_of_month
      
  end

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
    pay_period_date
    @url_user = User.find(params[:user_id])
    #@timesheets = Timesheet.where({:user_id => @url_user.id })
    if @is_first_part_of_month
      @timesheets = Timesheet.where("date >= :start_date AND date <= :end_date AND user_id = :url_user", {start_date: Date.today.at_beginning_of_month, end_date: (Date.today.at_beginning_of_month + 14), url_user: @url_user.id}).order("date ASC")
    else
      @timesheets = Timesheet.where("date >= :start_date AND date <= :end_date AND user_id = :url_user", {start_date: (Date.today.at_beginning_of_month + 15), end_date: (Date.today.end_of_month), url_user: @url_user.id}).order("date ASC")
    end
    @total_hours = 0
    @timesheets.each do |timesheet|
    @total_hours = @total_hours + timesheet.hours
    end
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
