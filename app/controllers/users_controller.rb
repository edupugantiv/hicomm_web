class UsersController < ApplicationController 
	before_action :authenticate_user!
	def show 
		@user = User.find(params[:id])
		@projects = @user.projects
		@groups = @user.groups
		@contacts = @user.colleagues
	end 

	def new 
		@user = User.new(sign_up_params)
	end 

	def create
		@user = User.create(user_params)
	end 

	def edit 
		@user = User.find(params[:id])
	end 

	def update 
		@user = User.find(params[:id])
		@user.update_attributes(account_update_params)
	end 

	def manage 
		@user = User.find(params[:id])
	end 

	def add_colleague
		@user = current_user 
		@colleague = User.find(params[:id]) 
		@user.colleagues << @colleague
		@colleague.colleagues << @user
		redirect_to :back, notice: "#{@colleague.name} has been added to your contacts"
	end 

	def remove_colleague 
		@user = current_user 
		@colleague = User.find(params[:id]) 
		@user.colleagues.delete(@colleague)
		@colleague.colleagues.delete(@user)
		redirect_to :back, notice: "#{@colleague.name} has been removed from your contacts"
	end 

	private 

	def user_params 
		params.require(:user).permit(:name, :job, :location, :mobile, :email)
	end 

end 