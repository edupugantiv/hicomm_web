class CreatePaypalNotifications < ActiveRecord::Migration
  def change
    create_table :paypal_notifications do |t|
      t.string :action
      t.string :ipn_track_id
      t.string :profile_id
      t.integer :subscription_id
      t.boolean :is_read, default: false


      t.timestamps null: false
    end
  end
end
