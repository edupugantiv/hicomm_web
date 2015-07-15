class WelcomeController < ApplicationController
	#before_action :authenticate_user!
	def index 
	end 

	def home 
		@user = current_user 
		@projects = @user.projects
		@conversations = @user.conversations 
		@groups = @user.groups
		@messages = []
		@conversations.each do |conversation|
			@messages += conversation.messages
		end 
		@requests = LeadProject.where(:user_id => @user.id, :pending => true)
	end 

	def search
	  @results = []
	  #if params[:search]
	  @users = User.search(params[:search])#.order("created_at DESC")
	  @projects = Project.search(params[:search])#.order("created_at DESC")
	  @groups = Group.search(params[:search])#.order("created_at DESC")
	  #else
	    #@posts = Post.all.order('created_at DESC')
	  #end
	end
end 