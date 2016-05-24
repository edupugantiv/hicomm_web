class AddSlugToConversation < ActiveRecord::Migration
  def change
    add_column :conversations, :slug, :string
    add_index :conversations, :slug, unique: true
  end
end
