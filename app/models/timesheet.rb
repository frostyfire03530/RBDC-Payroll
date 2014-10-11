class Timesheet < ActiveRecord::Base
    belongs_to :user

    validates :date, :timein, :timeout, :hours, :description, :payrate, :project, presence: true
    validate :timesheet_cannot_be_in_the_future, :timeout_cannot_be_before_timein, :date_is_not_in_pay_period, :timesheets_cannot_overlap
    
    def timesheet_cannot_be_in_the_future
        #Check if the user has inputed a timeout that is after the current time and if true create an error.
        if timeout.present? && timeout >= Time.now
            errors.add(:timeout, "cannot be for a future time")
        end
        
        #Check if the user has inputed a date that is after the current date and if true create an error.
        if date.present? && date > Date.today
            errors.add(:date, "cannot be for a future date")
        end
    end
    
    def timeout_cannot_be_before_timein
        if (timeout.present? && timein.present?) && timeout <= timein
            errors.add(:timeout, "cannot be before timein")
        end
    end
    
    def date_is_not_in_pay_period
        current_date = Date.today
        is_first_part_of_month = false
        is_same_month_and_year = false
        if current_date.strftime("%d").to_i <= 15
            is_first_part_of_month = true
        end
        if (current_date.strftime("%Y") == date.strftime("%Y")) && (current_date.strftime("%m") == date.strftime("%m"))
            is_same_month_and_year = true
        end
        if !is_same_month_and_year
            errors.add(:date, "is not in pay period")
        elsif (is_same_month_and_year && is_first_part_of_month) && date.strftime("%d").to_i >= 16
            errors.add(:date, "is not in pay period")
        elsif (is_same_month_and_year && !is_first_part_of_month) && date.strftime("%d").to_i <= 15
            errors.add(:date, "is not in pay period")
        end
    end
    
    def timesheets_cannot_overlap
        #Grab all the timesheets for the current_user
        user_timesheets = Timesheet.where(user_id: @url_user.id)
    
        #Loop through each of the current_user's timesheets
        user_timesheets.each do | user_timesheet |
      
            #Check to see if the timein / timeout is between the current timesheet, if true create an error and break out of the loop.
            if timein > user_timesheet.timein && timein < user_timesheet.timeout
                errors.add(:timein, "cannot overlap with previous timesheet.")
                errors.add(:timeout, "cannot overlap with previous timesheet.")
                break
            end
            if timeout > user_timesheet.timein && timeout < user_timesheet.timeout
                errors.add(:timein, "cannot overlap with previous timesheet.")
                errors.add(:timeout, "cannot overlap with previous timesheet.")
                break
            end
        end    
    end
    
end
