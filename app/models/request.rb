class Request <ActiveRecord::Base
	belongs_to :user
	belongs_to :project
	belongs_to :group

  delegate :name, :email, :mobile, :to => :user, :prefix => true
  delegate :name, :to => :project, :prefix => true
  delegate :name, :to => :group, :prefix => true


  scope :pending, -> { where(:pending => true) }

		def Request.approve_request(request, user, project, group)

			if request.type == 'JoinProject'
				project.users << User.find(request.request_by)
				project.conversations.find_by(:name => "Project-Wide Conversation").users << User.find(request.request_by)
				request.update_attributes(:pending => false)
			elsif request.type == 'LeadProject'
				project.update_attributes(:project_manager_id => request.request_to)
				request.update_attributes(:pending => false)
			elsif request.type == 'JoinGroup'
				group.users << User.find(request.request_by)
				request.update_attributes(:pending => false)
			elsif request.type == 'LeadGroup'
				group.update_attributes(:group_leader_id => request.request_to)
				request.update_attributes(:pending => false)
			elsif request.type == 'NewUser'
				User.find(request.request_by).update(is_active: true)
				request.update_attributes(:pending => false)
			elsif request.type == 'NewProject'
				project.update(is_active: true)
				request.update_attributes(:pending => false)
			elsif request.type == 'NewGroup'
				group.update(is_active: true)
				request.update_attributes(:pending => false)
			end
		end
end