class CreateJoinTableContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :user
      t.references :colleague
    end
  end
end
