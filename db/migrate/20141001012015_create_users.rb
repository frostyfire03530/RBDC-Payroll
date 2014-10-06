class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.decimal :payrate
      t.string :role
      t.boolean :active
      
      t.timestamps
    end
  end
end
