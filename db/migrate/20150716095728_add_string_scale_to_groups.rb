class AddStringScaleToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :scale, :string
  end
end
