class User < ActiveRecord::Base 
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	has_and_belongs_to_many :projects, join_table: "participants"
	has_many :groups, through: :organizations
	has_and_belongs_to_many :conversations, join_table: "conversers"
	has_many :groups
	#has_many :managed_projects, :class_name => "Project"

	def self.search(search)
  		where("name LIKE ?", "%#{search}%") 
  		#where("content LIKE ?", "%#{search}%")
	end
end 