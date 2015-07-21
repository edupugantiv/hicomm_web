class CreateJoinTableMembers < ActiveRecord::Migration
  def change
    create_join_table :group, :user, table_name: :members do |t|
      # t.index [:group_id, :user_id]
      # t.index [:user_id, :group_id]
    end
  end
end
