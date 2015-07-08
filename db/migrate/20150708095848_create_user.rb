class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :job
      t.string :location
      t.string :mobile
    end
  end
end
