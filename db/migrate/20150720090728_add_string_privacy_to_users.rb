class AddStringPrivacyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :privacy, :string
  end
end
