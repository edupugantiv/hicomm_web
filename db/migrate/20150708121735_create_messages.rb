class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.datetime :sent
      t.references :sender
      t.references :conversation

      t.timestamps null: false
    end
  end
end
