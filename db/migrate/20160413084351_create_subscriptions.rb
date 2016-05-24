class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :plan
      t.string :payer_email
      t.string :payer_id
      t.boolean :is_through_card
      t.integer :card_id
      t.boolean :is_recurring, default: true
      t.string :transaction_id
      t.string :profile_id
      t.integer :cycle_count, default: 1
      t.string :payment_status, default: 'active'
      t.boolean :is_success
      t.string :notification_params
      t.float :total_amount
      t.float :total_mc_gross
      t.float :total_mc_fee
      t.float :total_tax
      t.float :amount
      t.float :mc_gross
      t.float :mc_fee
      t.float :tax
      t.boolean :is_active
      t.references :user
      t.references :project



      t.timestamps null: false
    end
  end
end
