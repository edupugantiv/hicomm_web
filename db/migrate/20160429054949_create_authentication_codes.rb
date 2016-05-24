class CreateAuthenticationCodes < ActiveRecord::Migration
  def change
    create_table :authentication_codes do |t|
      t.string :phone_number
      t.string :code
      t.string :clickatell_message_id

      t.timestamps null: false
    end
  end
end
