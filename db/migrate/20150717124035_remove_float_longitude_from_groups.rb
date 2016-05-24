class RemoveFloatLongitudeFromGroups < ActiveRecord::Migration
  def change
  	remove_column :groups, :longitude, :float
  end
end
