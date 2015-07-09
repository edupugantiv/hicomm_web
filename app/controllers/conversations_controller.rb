class ConversationsController < ApplicationController 
	before_action :authenticate_user!
	def show 
		@conversation = Conversation.find(params[:id])
		@conversers = @conversation.users
		@messages = @conversation.messages
		@project = @conversation.project
	end 

	def new 
		@project = Project.find(params[:id])
		@users = @project.users.collect {|p| [ p.name, p.id ] }
		@conversation = Conversation.new
	end 

	def create 
		@project = Project.find(params[:id])
		@conversation = Conversation.create(conversation_params.merge(:project_id => @project.id))
		current_user.conversations << @conversation
		redirect_to welcome_path
	end 

	private 

	def conversation_params 
		params.require(:conversation).permit(:name)
	end 


end 