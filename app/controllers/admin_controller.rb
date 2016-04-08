class AdminController < ApplicationController 
  before_action :authenticate_user!
  before_action :is_admin


	def change_user_status

		user = User.find(params[:id])
		
		if user.is_active
			user.update(:is_active => false)
		else
			user.update(:is_active => true)
		end	

		redirect_to :back, notice: "User's status has been updated!"
	end

	def change_project_status
		
		project = Project.find(params[:id])
		
		if project.is_active
		  project.update(:is_active => false)
	  else
	    project.update(:is_active => true)
		end
		redirect_to :back, notice: "Project's status has been updated!"
	end

	def change_group_status
		
		group = Group.find(params[:id])
		if group.is_active
			group.update(:is_active => false)
		else
			group.update(:is_active => true)
		end	

		redirect_to :back, notice: "Group's status has been updated!"
	end

	def is_admin
		current_user.is_admin?
	end	

end