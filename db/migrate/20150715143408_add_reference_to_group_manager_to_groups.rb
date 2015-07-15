class AddReferenceToGroupManagerToGroups < ActiveRecord::Migration
  def change
    change_table(:groups) do |t|
  		t.references :group_leader
  	end 
  end
end
