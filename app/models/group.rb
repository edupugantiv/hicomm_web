class Group < ActiveRecord::Base
  	belongs_to :group_leader, :class_name => "User"
  	#has_many :users, through: :organizations
  	has_and_belongs_to_many :users, join_table: "members"
  	has_many :requests
  	has_and_belongs_to_many :projects, join_table: "affiliations"
  	has_many :posts
    validates_uniqueness_of :name, :message => "Sorry, this group name has already been taken"

    has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
    validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  	def self.search(search)
  		return where("name LIKE ?", "%#{search}%") - where(:privacy => "private")
  		#where("content LIKE ?", "%#{search}%")
	end

end
