class AddIsActiveToProjectAndGroup < ActiveRecord::Migration
  def change
    add_column :projects, :is_active, :boolean, :default => false
    add_column :groups, :is_active, :boolean, :default => false

  end
end
