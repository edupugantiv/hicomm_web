class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.references :subscription
      t.string :name
      t.string :card_type
      t.string :expiry_month
      t.string :expiry_year
      t.string :card_number
      t.string :cvc
      t.string :ip_address

      t.timestamps null: false
    end
  end
end
