class UsersController < ApplicationController 
	before_action :authenticate_user!
	def show 
		@user = User.find(params[:id])
		if @user == current_user 
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
		@user = User.find(params[:id])
		@user.save
	end 

	def update 
		@user = User.find(params[:id])
		@user.update_attributes(user_params)
		redirect_to manage_user_path(@user), notice: "Your account was successfully updated"
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
		params.require(:user).permit(:name, :job, :location, :mobile, :email, :privacy, :avatar)
	end 

	def account_update_params 
		params.require(:user).permit(:name, :location, :job, :mobile, :email, :password, :password_confirmation, :current_password, :privacy)
	end 

end 