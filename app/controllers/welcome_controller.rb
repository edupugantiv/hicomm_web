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
	end 
end 