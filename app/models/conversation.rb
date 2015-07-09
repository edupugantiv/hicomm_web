class Conversation < ActiveRecord::Base 
	has_and_belongs_to_many :users, join_table: "conversers"
	belongs_to :project
end 