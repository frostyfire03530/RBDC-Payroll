class AccountingController < ApplicationController
  before_action :set_accounting, only: [:show, :edit, :update, :destroy]
    
  


  # GET /accounting
  def index
      @projects = Project.all
      @users_active = User.where(active: true)
      @users_inactive = User.where(active: false)
    #earliest_date = Model.first(:order => 'column asc')
      @oldest_date_in_timesheet = Timesheet.pluck(:date).sort.first
      
      is_first_part_of_month = false
      if @oldest_date_in_timesheet.strftime("%d").to_i <= 15
        is_first_part_of_month = true
      end
      
      @payperiods = []
      
      if is_first_part_of_month
        @payperiods << @oldest_date_in_timesheet.strftime("%m/01/%Y -> %m/15/%Y")
      else
        @payperiods << @oldest_date_in_timesheet.end_of_month.strftime("%m/16/%Y -> %m/%d/%Y")
      end
      
      #if is_first_part_of_month
      #  @timesheets = Timesheet.where("date >= :start_date AND date <= :end_date", {start_date: @oldest_date_in_timesheet.at_beginning_of_month, end_date: (@oldest_date_in_timesheet.at_beginning_of_month + 14)}.order("date ASC")
      #else
      #  @timesheets = Timesheet.where("date >= :start_date AND date <= :end_date AND user_id = :url_user", {start_date: (Date.today.at_beginning_of_month + 15), end_date: (Date.today.end_of_month), url_user: @url_user.id}).order("date ASC")
      #end
          

      
      
      #@results = ActiveRecord::Base.connection.select_all(query)
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_accounting
      @accounting = Accounting.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def accounting_params
        params.require(:accounting).permit(:id)
    end
end
