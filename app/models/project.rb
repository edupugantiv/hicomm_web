class Project < ActiveRecord::Base
	belongs_to :project_manager, :class_name => "User"
	has_many :conversations
	has_and_belongs_to_many :users, join_table: "participants"
  has_many :requests
  has_many :lead_projects
  has_many :join_projects
	has_one :new_project
	has_and_belongs_to_many :groups, join_table: "affiliations"
  paginates_per 6

	has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
	validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  delegate :name, :email, :mobile, :to => :project_manager, :prefix => true


  has_many :messages, :through => :conversations

  has_many :subscriptions

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  after_create :attach_to_manager
  after_create :create_project_wide_conversation
  after_create :assign_tag

  scope :active, -> { where(:is_active => true) }

  # scope :paid, ->{ Project.where(:is_finished => false).where("date between ? and ?", DateTime.current - 2.hours, DateTime.current) }



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

  def assign_tag
    tag = Faker::Number.hexadecimal(3)
    while Project.find_by(:code => tag)
      tag = Faker::Number.hexadecimal(3)
    end
    update(:code => tag)
  end

  def paypal_url(return_path)
    values = {
      business: "hicomm.test.1-facilitator@gmail.com",
      return: "#{Rails.application.secrets.app_host}#{return_path}",
      notify_url: "#{Rails.application.secrets.app_host}/paypal_hook",
      invoice: self.id,
      item_name: self.name,
      cmd: "_xclick-subscriptions",
      a3: 1.00,
      p3: 1,
      srt: 50,
      t3: 'Day',
    }

    "#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" + values.to_query

  end

  def self.paid
    paid_projects = []
    paid_but_not_confirmed_projects = []

    Project.includes(:subscriptions).all.each do |project|
      project.subscriptions.each do |subscription|
        paid_projects << project if subscription.is_active
        paid_but_not_confirmed_projects << project if subscription.is_active.nil?
      end
    end
    [paid_projects, paid_but_not_confirmed_projects]
  end


  private

  def send_request_to_admin
    NewProject.create(:project_id => self.id, :request_by => self.project_manager_id, :request_to => Admin.first.id, :pending => true)
  end

  def slug_candidates
    [
      :name,
      [:name, :location],
      [:name, :location, :code]
    ]
  end

end