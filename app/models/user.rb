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

	has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
 	validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  
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

    private

    def send_request_to_admin
      NewUser.create(:user_id => self.id, :pending => true)
    end  

end 