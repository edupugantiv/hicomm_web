class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.references :user
      t.references :project
      t.references :group
      t.boolean :pending
      t.string :type
    end
  end
end
