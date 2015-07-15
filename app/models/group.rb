class Group < ActiveRecord::Base
  	has_many :users, through: :organizations
  	has_many :requests
  	has_and_belongs_to_many :projects, join_table: "affiliations"

  	def self.search(search)
  		where("name LIKE ?", "%#{search}%") 
  		#where("content LIKE ?", "%#{search}%")
	end

end
