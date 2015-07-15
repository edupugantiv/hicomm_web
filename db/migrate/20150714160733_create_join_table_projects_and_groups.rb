class CreateJoinTableProjectsAndGroups < ActiveRecord::Migration
  def change
    create_join_table :projects, :groups, table_name: :affiliations  do |t|
      # t.index [:project_id, :group_id]
      # t.index [:group_id, :project_id]
    end
  end
end
