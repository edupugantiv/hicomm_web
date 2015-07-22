class ProjectsController < ApplicationController 
	before_action :authenticate_user!
	def show 
		@user = current_user
		@project = Project.find(params[:project_id])
		@conversations = @project.conversations
		@participants = @project.users
		@project_manager = @project.project_manager
		if params[:conversation_id].nil? 
			@current_convo = @project.conversations.first 
		else 
			@current_convo = Conversation.find(params[:conversation_id])
		end 
		@message = Message.new
	end 

	def edit 
		@project = Project.find(params[:id])
	end 

	def update 
		@project = Project.find(params[:id])
		@project.update_attributes(project_params)
		redirect_to manage_project_path(@project), notice: "Your project information has been edited"
	end 

	def new 
		@project = Project.new
	end 

	def create 
		@project = Project.create(project_params.merge(:project_manager_id => current_user.id))
		current_user.projects << @project
		#current_user.managed_projects << @project
		@project_wide_convo = Conversation.create(:name => "Project-Wide Conversation", :project_id => @project.id)
		@project_wide_convo.users << current_user
		redirect_to project_path(:project_id => @project, :conversation_id => @project_wide_convo)
	end 

	def destroy 
		@project = Project.find(params[:id])
		@project.destroy
	end 

	def join 
		@project = Project.find(params[:id])
		# @project.users << current_user 
		@request = Request.create(:project_id => @project.id, :user_id => current_user.id, :pending => true, :type => 'JoinProject')
		redirect_to :back, notice: "Your request to join #{@project.name} has been sent"
	end 

	def leave 
		@project = Project.find(params[:id])
		@project.users.delete(current_user)
		redirect_to :back
	end 

	def pick_users
		@project = Project.find(params[:id])
		all_users = User.all
		existent_users = @project.users
		@users = all_users - existent_users
	end 

	def add_users
		@project = Project.find(params[:project_id])
		@user = User.find(params[:user_id])
		@project.users << @user
		@project_wide_convo = @project.conversations.where(:name => "Project-Wide Conversation")
		@user.conversations << @project_wide_convo
		redirect_to :back,  notice: "#{@user.name} was successfully added to #{@project.name}"
	end

	def manage_participants
		@project = Project.find(params[:id])
		@participants = @project.users 
		@requests = JoinProject.where(:project_id => @project.id, :pending => true)
	end 

	def remove_participants
		@project = Project.find(params[:id])
		@participants = @project.users - [@project.project_manager]
	end 

	def remove_participant 
		@project = Project.find(params[:project_id])
		@user = User.find(params[:user_id])
		@project.users.delete(@user)
		redirect_to :back, notice: "#{@user.name} was successfully removed from #{@project.name}"
	end 

	def transfer_leadership
		@project = Project.find(params[:id])
		@participants = @project.users - [current_user] 
	end 

	def new_leader
		@project = Project.find(params[:project_id])
		@user = User.find(params[:user_id])
		@request = Request.create(:project_id => @project.id, :user_id => @user.id, :pending => true, :type => 'LeadProject')
		#@project.update_attributes(:project_manager_id => @user.id)
		redirect_to project_path(:project_id =>@project, :conversation_id => @project.conversations.first), notice: "leadership of #{@project.name} will be transfered to #{@user.name} upon approval"
	end 

	def add_affiliations 
		@project = Project.find(params[:id])
		@groups = Group.all - @project.groups
	end 

	def affiliate 
		@project = Project.find(params[:project_id])
		@group = Group.find(params[:group_id])
		if @project.groups.size < 3
			@project.groups << @group 
			redirect_to :back, notice: "#{@project.name} has been affiliated with #{@group.name}"
		else 
			redirect_to :back, notice: "Sorry, #{@project.name} already has too many affiliations"
		end 
	end 

	def change_plan 
		@project = Project.find(params[:id])
	end

	private 

	def project_params 
		params.require(:project).permit(:name, :privacy, :plan, :location, :scale, :avatar)
	end

end 