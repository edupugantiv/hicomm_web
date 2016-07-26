class ProjectsController < ApplicationController
    before_filter :check_project_manager, except: [:index, :show, :new, :create, :join, :leave, :list_of_users]

  def index
  	@projects = current_user.projects.order(:name).page params[:page]
  end

	def show
		@user = current_user
		@project = Project.includes(:conversations, :users, :project_manager).friendly.find(params[:project_id])
		# if Project.paid.first.include? @project
			@conversations = @project.conversations.includes(:users)
			@participants = @project.users.limit(3)
			@project_manager = @project.project_manager
			if params[:conversation_id].nil?
				@current_convo = @project.conversations.first
			else
				@current_convo = Conversation.friendly.find(params[:conversation_id])
			end
			@messages = @current_convo.messages.includes(:sender)
	    @messages.each do |message|
	    	if message.sender != current_user
	 	  		message.mark_as_read! :for => current_user
 	  		end
    	end
	  	@conversation_users =  @current_convo.users

			@message = Message.new
  		@join_request_sent = !(JoinProject.pending.where(:request_by => current_user.id, :project_id => @project.id).blank?)

		# elsif Project.paid.last.include? @project
		# 	if current_user.managed_projects.include? @project
		# 		redirect_to home_path, :alert => "We still didn't get a payment confirmation of #{@project.name} from PayPal. So please come back after some time."
		# 	else
		# 		redirect_to home_path, :alert => 'You do not have access to this project'
		# 	end
		# elsif current_user.managed_projects.include? @project
		# 	redirect_to pay_path(@project), :alert => 'Please finish the payment to get into the project'
		# else
		# 	redirect_to home_path, :alert => 'You do not have access to this project'
		# end
	end

	def edit
		@project = Project.friendly.find(params[:id])
	end

	def update
		@project = Project.friendly.find(params[:id])
		@project.update_attributes(project_params)
		redirect_to :back, notice: "Your project information has been edited"
	end

	def new
		@project = Project.new
	end

	def create
		@project = Project.create(project_params.merge(:project_manager_id => current_user.id))
		if @project.save
			project_create_notifications(@project)
			redirect_to project_path(@project)
	    	# redirect_to pay_path(@project)
	    else
	      render :new
    end
		# redirect_to project_path(:project_id => @project, :conversation_id => @project.conversations.first)
	end

	def destroy
		@project = Project.friendly.find(params[:id])
		@project.destroy
	end

	def list_of_users
		@project = Project.includes(:users).friendly.find(params[:id])
		@users = @project.users
		@user_count = @users.size
	end

	def join
		@project = Project.friendly.find(params[:id])

		@request = Request.create(:project_id => @project.id, :user_id => current_user.id, :request_by => current_user.id,
			:request_to => @project.project_manager_id,:pending => true, :type => 'JoinProject')

		if @request.save!
			 project_join_request_notifications(@project)
		end
		redirect_to :back, notice: "Your request to join #{@project.name} has been sent"
	end

	def leave
		@project = Project.friendly.find(params[:id])
		@project.users.delete(current_user)
		leave_notification(@project, current_user)
		redirect_to :back
	end

	def pick_users
		@project = Project.friendly.find(params[:id])
		all_users = User.all
		existent_users = @project.users
		@users = all_users - existent_users
	end

	def add_users
		@project = Project.friendly.find(params[:project_id])
		@user = User.friendly.find(params[:user_id])
		@project.users << @user
		@project_wide_convo = @project.conversations.where(:name => "Project-Wide Conversation")
		@user.conversations << @project_wide_convo
		add_members_notification_to_user(@project, @user)
		redirect_to :back,  notice: "#{@user.name} was successfully added to #{@project.name}"
	end

	def manage_participants
		@project = Project.friendly.find(params[:id])
		@participants = @project.users
		@requests = JoinProject.where(:project_id => @project.id, :pending => true)
	end

	def remove_participants
		@project = Project.friendly.find(params[:id])
		@participants = @project.users - [@project.project_manager]
	end

	def remove_participant
		@project = Project.friendly.find(params[:project_id])
		@user = User.friendly.find(params[:user_id])
		@project.users.delete(@user)
		remove_members_notification_to_user(@project, @user)
		redirect_to :back, notice: "#{@user.name} was successfully removed from #{@project.name}"
	end

	def transfer_leadership
		@project = Project.friendly.find(params[:id])
		@participants = @project.users - [current_user]

		@requests_sent_by_user = LeadProject.pending.where(:request_by => current_user.id, :project_id => @project.id)
		@transfer_request_sent = !(@requests_sent_by_user.blank?)
		@transfer_leadership_to = User.find(@requests_sent_by_user.last.request_to) if @transfer_request_sent
	end

	def new_leader
		@project = Project.friendly.find(params[:project_id])
		@user = User.friendly.find(params[:user_id])
		@request = Request.create(:project_id => @project.id, :user_id => @user.id, :request_to => @user.id, :request_by => @project.project_manager_id, :pending => true, :type => 'LeadProject')
		redirect_to project_path(:project_id =>@project, :conversation_id => @project.conversations.first), notice: "leadership of #{@project.name} will be transfered to #{@user.name} upon approval"
	end

	def add_affiliations
		@project = Project.friendly.find(params[:id])
		@groups = Group.all - @project.groups
	end

	def affiliate
		@project = Project.includes(:groups).friendly.find(params[:project_id])
		@group = Group.friendly.find(params[:group_id])
		if @project.groups.size < 3
			@project.groups << @group
			redirect_to :back, notice: "#{@project.name} has been affiliated with #{@group.name}"
		else
			redirect_to :back, notice: "Sorry, #{@project.name} already has too many affiliations"
		end
	end

	def change_plan
		@project = Project.friendly.find(params[:id])
	end

	def dashboard
		@project = Project.friendly.find(params[:id])
		@total_messages_count = @project.messages.count
		@join_request_sent = !(JoinProject.pending.where(:request_by => current_user.id, :project_id => @project.id).blank?)
	end

	private

	def check_project_manager
		project = Project.friendly.find(params[:id])
		if current_user.managed_projects.include? project
			true
		else
			redirect_to project_path(project), notice: "Sorry, you cannot access this path."
		end
	end

	def project_params
		params.require(:project).permit(:name, :privacy, :plan, :location, :scale, :avatar)
	end

	def project_join_request_notifications(project)
		message_to_project_manager = "<a href=#{user_path(current_user)}>#{current_user.name.capitalize}</a> has requested
  		to join the project <a href=#{project_path(project)}>#{project.name}</a>. Please go to this <a href=#{requests_path}>link</a> to approve it."
		message_to_user = "Your request has been successfully placed to join the project <a href=#{project_path(project)}>#{project.name}</a>"

		Notification.send_notification(project.project_manager, 'Join Project', message_to_project_manager)
		Notification.send_notification(current_user, 'Join Project', message_to_user)
	end

	def project_create_notifications(project)
		message_to_project_manager = "You have successfully created a new project named <a href=#{project_path(project)}>#{project.name}</a>"
    message_to_admin = "A new project named <a href=#{project_path(project)}>#{project.name}</a> is created. Please go to this <a href=#{requests_path}>link</a> to approve it."
    admin = Admin.first

    Notification.send_notification(admin, 'New Project Created', message_to_admin)
		Notification.send_notification(project.project_manager, 'New Project Create', message_to_project_manager)
	end

  def project_new_leader_notifications(project, user)
    message_to_project_manager = "You have successfully requested <a href=#{user_path(user)}>#{user.name}</a>
       to lead project named <a href=#{project_path(project)}>#{project.name}</a>."
    message_to_user = "<a href=#{user_path(project.project_manager)}>#{project.project_manager.name.capitalize}</a>
      has requested you to lead project named <a href=#{project_path(project)}>#{project.name}</a>.
      Please go to this <a href=#{requests_path}>link</a> to approve it."

    Notification.send_notification(user, 'New Project Leader Request', message_to_user)
    Notification.send_notification(project.project_manager, 'New Project Leader Request', message_to_project_manager)
  end

  def add_members_notification_to_user(project, user)
  	message = "You have been added to project named <a href=#{project_path(project)}>#{project.name}</a>."
    Notification.send_notification(user, 'Added to Project', message)
  end

  def remove_members_notification_to_user(project, user)
  	message = "You have been removed from project named <a href=#{project_path(project)}>#{project.name}</a>."
    Notification.send_notification(user, 'Removed from Project', message)
  end


  def leave_notification(project, user)
    message_to_user = "You have left project named <a href=#{project_path(project)}>#{project.name}</a>."
    message_to_project_manager = " <a href=#{user_path(current_user)}>#{current_user.name.capitalize}</a> has left project named <a href=#{project_path(project)}>#{project.name}</a>."

    Notification.send_notification(user, 'Left from Project', message_to_user)
    Notification.send_notification(project.project_manager, 'Left from Project', message_to_project_manager)
  end

end