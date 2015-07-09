class AddStringPlanToProject < ActiveRecord::Migration
  def change
  	change_table(:projects) do |t|
  		t.string :plan
  	end 
  end
end
