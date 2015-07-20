class User < ActiveRecord::Base 
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	has_and_belongs_to_many :projects, join_table: "participants"
	has_many :groups, through: :organizations
	has_and_belongs_to_many :conversations, join_table: "conversers"
	has_and_belongs_to_many :groups, join_table: 'members'
	has_many :contacts 
	has_many :colleagues, :through => :contacts
	validates_acceptance_of :terms_of_use

	def self.search(search)
  		where("name LIKE ?", "%#{search}%") 
  		#where("content LIKE ?", "%#{search}%")
	end
end 