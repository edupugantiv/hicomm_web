class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.references :subscription, index: true, foreign_key: true
      t.datetime :date
      t.boolean :is_finished

      t.timestamps null: false
    end
  end
end
