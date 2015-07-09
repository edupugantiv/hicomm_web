class UsersController < ApplicationController 
	before_action :authenticate_user!
	def show 
		@user = User.find(params[:id])
	end 

	def new 
		@user = User.new
	end 

	def create
		@user = User.create(user_params)
	end 

	def edit 
		@user = User.find(params[:id])
	end 

	def update 
		@user = User.find(params[:id])
		@user.update_attributes(user_params)
	end 

	private 

	def user_params 
		params.require(:user).permit(:name, :job, :location, :mobile, :email)
	end 

end 