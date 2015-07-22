class Project < ActiveRecord::Base 
	belongs_to :project_manager, :class_name => "User"
	has_many :conversations
	has_and_belongs_to_many :users, join_table: "participants"
	has_many :requests
	has_and_belongs_to_many :groups, join_table: "affiliations"

	has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  	validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

	def self.search(search)
  		where("name LIKE ?", "%#{search}%") - where(:privacy => "private")
  		#where("content LIKE ?", "%#{search}%")
	end
end 