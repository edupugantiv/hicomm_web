class AddProjectManagerIdToProjects < ActiveRecord::Migration
  def change
  	change_table(:projects) do |t|
  		t.references :project_manager
  	end 
  end
end
