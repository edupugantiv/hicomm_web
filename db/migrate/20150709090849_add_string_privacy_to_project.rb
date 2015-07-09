class AddStringPrivacyToProject < ActiveRecord::Migration
  def change
  	change_table(:projects) do |t|
  		t.string :privacy
  	end 
  end
end
