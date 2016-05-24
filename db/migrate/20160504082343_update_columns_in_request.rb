class UpdateColumnsInRequest < ActiveRecord::Migration
  def change
  	add_column :requests, :request_by, :integer
  	add_column :requests, :request_to, :integer
  end
end
