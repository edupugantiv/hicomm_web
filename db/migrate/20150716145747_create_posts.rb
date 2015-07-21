class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :body
      t.datetime :posted
      t.references :poster
      t.references :group
    end
  end
end
