class Timesheet < ActiveRecord::Base
    belongs_to :user

    validates :date, :timein, :timeout, :hours, :description, :payrate, :project, presence: true
    validate :check_if_current_user_is_url_user, :timesheet_cannot_be_in_the_future, :timeout_cannot_be_before_timein, :date_is_not_in_pay_period
    
    def check_if_current_user_is_url_user
        if current_user.id != @url_user.id
            redirect_to user_timesheets_path(current_user.id)
        end
    end
    
    def timesheet_cannot_be_in_the_future
        if timeout.present? && timeout >= Time.now
            return errors.add(:timeout, "cannot be for a future time")
        end
        
        if date.present? && date > Date.today
            return errors.add(:date, "cannot be for a future date")
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
            return errors.add(:date, "is not in pay period")
        end
        if (is_same_month_and_year && is_first_part_of_month) && date.strftime("%d").to_i >= 16
            return errors.add(:date, "is not in pay period")
        end
        if (is_same_month_and_year && !is_first_part_of_month) && date.strftime("%d").to_i <= 15
            return errors.add(:date, "is not in pay period")
        end
    end
        
end
