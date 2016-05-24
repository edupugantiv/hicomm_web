class Group < ActiveRecord::Base
    belongs_to :group_leader, :class_name => "User"
    #has_many :users, through: :organizations
    has_and_belongs_to_many :users, join_table: "members"
    has_many :requests
    has_many :lead_groups
    has_many :join_groups
    has_one :new_group
    has_and_belongs_to_many :projects, join_table: "affiliations"
    has_many :posts
    validates_uniqueness_of :name, :message => "Sorry, this group name has already been taken"
    paginates_per 6

    has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
    validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

    extend FriendlyId
    friendly_id :slug_candidates, use: :slugged

    delegate :name, :email, :mobile, :to => :group_leader, :prefix => true


    after_create :send_request_to_admin

    scope :active, -> { where(:is_active => true) }





  	def self.search(search)
  		return where("name LIKE ?", "%#{search}%") - where(:privacy => "private")
  		#where("content LIKE ?", "%#{search}%")
	  end

    private

    def send_request_to_admin
      NewGroup.create(:group_id => self.id, :request_by => self.group_leader_id, :request_to => Admin.first.id,
       :pending => true)
    end

    def slug_candidates
      [
        :name,
        [:name, :location]
      ]
    end


end
