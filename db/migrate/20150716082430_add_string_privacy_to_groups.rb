class AddStringPrivacyToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :privacy, :string
  end
end
