class UpdateJobTitleToJob < ActiveRecord::Migration
	def change
		rename_column :users, :job_title, :job
	end
end