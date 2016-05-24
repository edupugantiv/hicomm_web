class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.string :name
      t.references :project
    end
  end
end
