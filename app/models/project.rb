class Project < ActiveRecord::Base 
	belongs_to :project_manager, :class_name => "User"
	has_many :conversations
	has_many :users, through: :participants
end 