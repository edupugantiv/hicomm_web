class RemoveTypeFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :type, :string
  end
end
