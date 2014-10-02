class CreateTimesheets < ActiveRecord::Migration
  def change
    create_table :timesheets do |t|
      t.date :date
      t.datetime :timein
      t.datetime :timeout
      t.decimal :hours
      t.text :description
      t.decimal :payrate
      t.string :project
      t.references :user

      t.timestamps
    end
  end
end
