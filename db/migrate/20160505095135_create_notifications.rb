class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :subject
      t.string :body
      t.boolean :is_read
      t.references :user

      t.timestamps null: false
    end
  end
end
