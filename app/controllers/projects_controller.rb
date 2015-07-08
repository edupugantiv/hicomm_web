class ProjectsController < ApplicationController 
	before_action :authenticate_user
	def show 
		@project = Project.find(params[:id])
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
		@project = Project.create(project_params)
	end 

	def destroy 
		@project = Project.find(params[:id])
		@project.destroy
	end 

	private 

	def project_params 
		params.require(:project).permit(:name, :project_manager_id)
	end

end 