class ChangeTimesheets < ActiveRecord::Migration
    def up
        change_column :timesheets, :timein, :time
        change_column :timesheets, :timeout, :time  
    end
    
    def down
        change_column :timesheets, :timein, :datetime
        change_column :timesheets, :timeout, :datetime  
    end
    
end
