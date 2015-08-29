class Project < ActiveRecord::Base 
	belongs_to :project_manager, :class_name => "User"
	has_many :conversations
	has_and_belongs_to_many :users, join_table: "participants"
	has_many :requests
	has_and_belongs_to_many :groups, join_table: "affiliations"

	has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  	validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  after_create :attach_to_manager
  after_create :create_project_wide_conversation

	def self.search(search)
  		where("name LIKE ?", "%#{search}%") - where(:privacy => "private")
  		#where("content LIKE ?", "%#{search}%")
	end

  def attach_to_manager
    project_manager.projects << self
  end

  def create_project_wide_conversation
    conversation = conversations.create(:name => "Project-Wide Conversation")
    conversation.users << project_manager
  end

end