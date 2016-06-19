class UsersController < ApplicationController
	before_action :authenticate_user!
	before_filter :verify_current_user, only: [:edit, :update, :manage, :delete_account, :delete_user]
	
	def show
		@user = User.includes(:projects, :groups, :colleagues).friendly.find(params[:id])
		if current_user.slug == params[:id]
			@projects = @user.projects
			@groups = @user.groups
			@contacts = @user.colleagues
		else
			@projects = @user.projects - Project.where(:privacy => "private")
			@groups = @user.groups - Group.where(:privacy => "private")
			@contacts = @user.colleagues - User.where(:privacy => "private")
		end
	end

	def new
		@user = User.new(sign_up_params)
	end

	def create
		@user = User.create(user_params)
	end

	def edit
		@user = User.friendly.find(params[:id])
		@user.save
	end

	def update
		@user = User.friendly.find(params[:id])
		@user.update_attributes(user_params)
		redirect_to manage_user_path(@user), notice: "Your account was successfully updated"
	end

	def manage
		@user = User.friendly.find(params[:id])
	end

	def add_colleague
		@user = current_user
		@colleague = User.friendly.find(params[:id])
		@user.colleagues << @colleague
		@colleague.colleagues << @user
		redirect_to :back, notice: "#{@colleague.name} has been added to your contacts"
	end

	def remove_colleague
		@user = current_user
		@colleague = User.friendly.find(params[:id])
		@user.colleagues.delete(@colleague)
		@colleague.colleagues.delete(@user)
		redirect_to :back, notice: "#{@colleague.name} has been removed from your contacts"
	end

	def delete_account
		@user = current_user
	end

	def delete_user
		@user = current_user
		@user.update(is_active: false)
    sign_out current_user
    redirect_to new_user_session_path
	end

	private
	def user_params
		if current_user.is_admin?
			params.require(:admin).permit(:first_name, :last_name, :job, :location, :mobile, :email, :privacy, :avatar)
		else
			params.require(:user).permit(:first_name, :last_name, :job, :location, :mobile, :email, :privacy, :avatar)
		end
	end

	def account_update_params
		params.require(:user).permit(:first_name, :last_name, :location, :job, :mobile, :email, :password, :password_confirmation, :current_password, :privacy)
	end

	def verify_current_user
		@user = User.friendly.find(params[:id])
		if current_user.slug != params[:id]
			redirect_to errors_not_found_path
		end
	end
end