class Group < ActiveRecord::Base
  	belongs_to :group_leader, :class_name => "User"
  	#has_many :users, through: :organizations
  	has_and_belongs_to_many :users, join_table: "members"
  	has_many :requests
  	has_and_belongs_to_many :projects, join_table: "affiliations"
  	has_many :posts
    validates_uniqueness_of :name, :message => "Sorry, this group name has already been taken"

  	def self.search(search)
  		where("name LIKE ?", "%#{search}%") 
  		#where("content LIKE ?", "%#{search}%")
	end

end
