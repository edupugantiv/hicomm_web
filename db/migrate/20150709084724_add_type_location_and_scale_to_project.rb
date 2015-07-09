class AddTypeLocationAndScaleToProject < ActiveRecord::Migration
  def change
  	change_table(:projects) do |t|
  		t.string :type 
  		t.string :location 
  		t.string :scale 
  	end 
  end
end
