class ProjectsController < ApplicationController 
	before_action :authenticate_user!
	def show 
		@user = current_user
		@project = Project.find(params[:id])
		@conversations = @project.conversations
		@members = @project.users
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
		redirect_to 'welcom_path'
	end 

	def destroy 
		@project = Project.find(params[:id])
		@project.destroy
	end 

	private 

	def project_params 
		params.require(:project).permit(:name, :privacy, :plan)
	end

end 