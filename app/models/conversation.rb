class Conversation < ActiveRecord::Base 
	has_many :users, :through :conversers
	belongs_to :project
end 