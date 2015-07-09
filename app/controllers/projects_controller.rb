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
		@project.users << current_user 
		redirect_to :back
	end 

	def leave 
		@project = Project.find(params[:id])
		@project.users.delete(current_user)
		redirect_to :back
	end 

	private 

	def project_params 
		params.require(:project).permit(:name, :privacy, :plan, :location, :scale)
	end

end 