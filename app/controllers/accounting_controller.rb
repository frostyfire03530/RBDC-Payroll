class AccountingController < ApplicationController
  before_action :set_accounting, only: [:show, :edit, :update, :destroy]
    
  


  # GET /accounting
  def index
    #earliest_date = Model.first(:order => 'column asc')
      @results = Timesheet.pluck(:date).sort.first
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
