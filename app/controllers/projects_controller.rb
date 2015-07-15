class ProjectsController < ApplicationController 
	before_action :authenticate_user!
	def show 
		@user = current_user
		@project = Project.find(params[:id])
		@conversations = @project.conversations
		@participants = @project.users
		@project_manager = @project.project_manager
	end 

	def edit 
		@project = Project.find(params[:id])
	end 

	def update 
		@project = Project.find(params[:id])
		@project.update_attributes(project_params)
	end 

	def new 
		@project = Project.new
	end 

	def create 
		@project = Project.create(project_params.merge(:project_manager_id => current_user.id))
		current_user.projects << @project
		#current_user.managed_projects << @project
		redirect_to welcome_path
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
		redirect_to :back,  notice: "#{@user.name} was successfully added to #{@project.name}"
	end

	def manage_members 
		@project = Project.find(params[:id])
		@participants = @project.users 
		@requests = JoinProject.where(:project_id => @project.id, :pending => true)
	end 

	def remove_members
		@project = Project.find(params[:id])
		@participants = @project.users 
	end 

	def remove_member 
		@project = Project.find(params[:project_id])
		@user = User.find(params[:user_id])
		@project.users.delete(@user)
		redirect_to :back, notice: "#{@user.name} was successfully removed from #{@project.name}"
	end 

	def transfer_leadership
		@project = Project.find(params[:id])
		@participants = @project.users 
	end 

	def new_leader
		@project = Project.find(params[:project_id])
		@user = User.find(params[:user_id])
		@request = Request.create(:project_id => @project.id, :user_id => @user.id, :pending => true, :type => 'LeadProject')
		#@project.update_attributes(:project_manager_id => @user.id)
		redirect_to project_path(@project), notice: "leadership of #{@project.name} will be transfered to #{@user.name} upon approval"
	end 

	private 

	def project_params 
		params.require(:project).permit(:name, :privacy, :plan, :location, :scale)
	end

end 