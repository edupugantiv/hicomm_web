class Group < ActiveRecord::Base
  	has_many :users, through: :organizations
  	has_many :requests

  	def self.search(search)
  		where("name LIKE ?", "%#{search}%") 
  		#where("content LIKE ?", "%#{search}%")
	end

end
