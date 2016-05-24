class AddCodeToConversation < ActiveRecord::Migration
  def change
  	add_column :conversations, :code, :string
  end
end
