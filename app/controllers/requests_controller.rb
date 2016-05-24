class RequestsController <ApplicationController

	def index
		if current_user.is_admin?
			redirect_to home_path
		else
			@requests_by_me = current_user.requests_by_me
			@requests_to_me = current_user.requests_to_me
		end
	end

	def new
		@request = Request.new
	end

	def create
		@request = Request.create(request_params.merge(:pending => true))
	end

	def approve
		@request = Request.includes(:user, :project, :group).find(params[:id])
		@user = @request.user
		@project = @request.project
		@group = @request.group

		Request.approve_request(@request, @user, @project, @group)
		approve_request_notifications(@request, @user, @project, @group)

		redirect_to :back, notice: "Request Accepted"
	end

	def decline
		@request = Request.includes(:user, :project, :group).find(params[:id])
		@request.update_attributes(:pending => false)
		decline_request_notifications(@request, @request.user, @request.project, @request.group)
		redirect_to :back, notice: "Request Declined"
	end

	def cancel_request
		@request = Request.find(params[:id])
		@request.update_attributes(:pending => false)
		redirect_to :back, notice: "Request Cancelled"
	end

	private

	def request_params
		params.require(:request).permit(:user_id, :group_id, :project_id, :type)
	end

  def approve_request_notifications(request, user, project, group)
		if request.type == 'JoinProject'
			message_from_approver = "You have approved the join project request by
			 <a href=#{user_path(user)}>#{user.name}</a> into project <a href=#{project_path(project)}>#{project.name}</a>."
			message_to_approved = "Your join project request to <a href=#{project_path(project)}>#{project.name}</a> is approved and you can access it now."
			subject = "Join Project Request Approved"

		elsif request.type == 'LeadProject'
			message_from_approver = "You have approved the lead project request by
			 <a href=#{user_path(user)}>#{user.name}</a> to project <a href=#{project_path(project)}>#{project.name}</a>."
			message_to_approved = "Your transfer lead request of project <a href=#{project_path(project)}>#{project.name}</a> is approved."
			subject = "Lead Project Request Approved"

		elsif request.type == 'JoinGroup'
			message_from_approver = "You have approved the join group request by
			 <a href=#{user_path(user)}>#{user.name}</a> into group <a href=#{group_path(group)}>#{group.name}</a>."
			message_to_approved = "Your join group request to <a href=#{group_path(group)}>#{group.name}</a> is approved and you can access it now."
			subject = "Join Group Request Approved"

		elsif request.type == 'LeadGroup'
			message_from_approver = "You have approved the lead group request by
			 <a href=#{user_path(user)}>#{user.name}</a> to group <a href=#{group_path(group)}>#{group.name}</a>."
			message_to_approved = "Your transfer lead request of group <a href=#{group_path(group)}>#{group.name}</a> is approved."
			subject = "Lead Group Request Approved"

		elsif request.type == 'NewUser'
			message_from_approver = "You have approved the new user account of<a href=#{user_path(user)}>#{user.name}</a>."
			message_to_approved = "Your user account <a href=#{user_path(user)}>#{user.name}</a> is approved and everyone can see your profile now."
			subject = "New Account Approved"
			
		elsif request.type == 'NewProject'
			message_from_approver = "You have approved the new project <a href=#{project_path(project)}>#{project.name}</a>."
			message_to_approved = "Your project <a href=#{project_path(project)}>#{project.name}</a> is approved and everyone can access it now."
			subject = "New Project Approved"
			
		elsif request.type == 'NewGroup'
			message_from_approver = "You have approved the new group <a href=#{group_path(group)}>#{group.name}</a>."
			message_to_approved = "Your group <a href=#{group_path(group)}>#{group.name}</a> is approved and everyone can access it now."
			subject = "New Group Approved"
		end
		
		approver = User.find(request.request_to)
		approved = User.find(request.request_by)

    Notification.send_notification(approver, subject, message_from_approver)
    Notification.send_notification(approved, subject, message_to_approved)
  end

  def decline_request_notifications(request, user, project, group)
		if request.type == 'JoinProject'
			message_from_decliner = "You have declined the join project request by
			 <a href=#{user_path(user)}>#{user.name}</a> into project <a href=#{project_path(project)}>#{project.name}</a>."
			message_to_declined = "Your join project request to <a href=#{project_path(project)}>#{project.name}</a> is declined."
			subject = "Join Project Request Declined"

		elsif request.type == 'LeadProject'
			message_from_decliner = "You have declined the lead project request by
			 <a href=#{user_path(user)}>#{user.name}</a> to project <a href=#{project_path(project)}>#{project.name}</a>."
			message_to_declined = "Your transfer lead request of project <a href=#{project_path(project)}>#{project.name}</a> is declined.
			 You will be continue to be the project manager."
			subject = "Lead Project Request Declined"

		elsif request.type == 'JoinGroup'
			message_from_decliner = "You have declined the join group request by
			 <a href=#{user_path(user)}>#{user.name}</a> into group <a href=#{group_path(group)}>#{group.name}</a>."
			message_to_declined = "Your join group request to <a href=#{group_path(group)}>#{group.name}</a>."
			subject = "Join Group Request Declined"

		elsif request.type == 'LeadGroup'
			message_from_decliner = "You have declined the lead group request by
			 <a href=#{user_path(user)}>#{user.name}</a> to group <a href=#{group_path(group)}>#{group.name}</a>."
			message_to_declined = "Your transfer lead request of group <a href=#{group_path(group)}>#{group.name}</a> is declined.
			You will continue to be the group leader."
			subject = "Lead Group Request Declined"

		elsif request.type == 'NewUser'
			message_from_decliner = "You have declined the new user account of<a href=#{user_path(user)}>#{user.name}</a>."
			message_to_declined = "Your user account <a href=#{user_path(user)}>#{user.name}</a> is declined."
			subject = "New Account Declined"
			
		elsif request.type == 'NewProject'
			message_from_decliner = "You have declined the new project <a href=#{project_path(project)}>#{project.name}</a>."
			message_to_declined = "Your project <a href=#{project_path(project)}>#{project.name}</a> is declined."
			subject = "New Project Declined"
			
		elsif request.type == 'NewGroup'
			message_from_decliner = "You have declined the new group <a href=#{group_path(group)}>#{group.name}</a>."
			message_to_declined = "Your group <a href=#{group_path(group)}>#{group.name}</a> is declined."
			subject = "New Group Declined"
		end
		
		decliner = User.find(request.request_to)
		declined = User.find(request.request_by)

    Notification.send_notification(decliner, subject, message_from_decliner)
    Notification.send_notification(declined, subject, message_to_declined)
  end

end