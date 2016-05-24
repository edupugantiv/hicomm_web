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
  has_many :requests
  has_many :join_projects
  has_many :join_groups
  has_many :lead_groups
  has_many :lead_projects
  has_many :new_users
  has_many :new_groups
  has_many :new_projects
  has_many :notifications

  has_many :subscriptions

	has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
 	validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  
  after_create :send_request_to_admin

  scope :active, -> { where(:is_active => true) }

	def self.search(search)
  		return where("first_name LIKE ? OR last_name LIKE ?", "%#{search}%", "%#{search}%") - where(:privacy => "private")
	end

	def name 
		[first_name, last_name].join(' ')
	end

  def country_code
    case country
    when 'USA'
      '1'
    when 'South-Africa'
      '27'
    end
  end

  def full_number
    "#{country_code}#{mobile}"
  end

  def is_admin?
    self.type == 'Admin'
  end  

  def total_requests_count
    if !self.is_admin?
      self.requests_by_me[:requests_by_me_count] + self.requests_to_me[:requests_to_me_count]
    end
  end 

  def requests_by_me
    join_group_requests = JoinGroup.pending.where(:request_by => self.id)
    join_project_requests = JoinProject.pending.where(:request_by => self.id)
    lead_group_requests = LeadGroup.pending.where(:request_by => self.id)
    lead_project_requests = LeadProject.pending.where(:request_by => self.id)

    requests_by_me_count = join_group_requests + join_project_requests + lead_group_requests + lead_project_requests
    requests_by_me = {:join_group_requests => join_group_requests, :join_project_requests => join_project_requests, 
    :lead_group_requests => lead_group_requests, :lead_project_requests => lead_project_requests, 
    :requests_by_me_count => requests_by_me_count.size}
  end

  def requests_to_me
    join_group_requests = JoinGroup.pending.where(:request_to => self.id)
    join_project_requests = JoinProject.pending.where(:request_to => self.id)
    lead_group_requests = LeadGroup.pending.where(:request_to => self.id)
    lead_project_requests = LeadProject.pending.where(:request_to => self.id)

    requests_to_me_count = join_group_requests + join_project_requests + lead_group_requests + lead_project_requests
    requests_to_me = {:join_group_requests => join_group_requests, :join_project_requests => join_project_requests, 
    :lead_group_requests => lead_group_requests, :lead_project_requests => lead_project_requests, 
    :requests_to_me_count => requests_to_me_count.size}
  end

  def managed_projects
    self.projects.where(project_manager_id: self.id)
  end

  def managed_groups
    self.groups.where(group_leader_id: self.id)
  end

  private

    def send_request_to_admin
      NewUser.create(:user_id => self.id, :request_by => self.id, :request_to => Admin.first.id, :pending => true)
    end  

    def slug_candidates
      [
        :name,
        [:name, :location],
        [:name, :location, :country],
        [:name, :location, :country, :job]
      ]
    end


end 