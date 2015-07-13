class ConversationsController < ApplicationController 
	before_action :authenticate_user!
	def show 
		@conversation = Conversation.find(params[:id])
		@conversers = @conversation.users
		@message = Message.new
		@messages = @conversation.messages
		@project = @conversation.project
	end 

	def new 
		@project = Project.find(params[:id])
		#@users = @project.users.collect {|p| [ p.name, p.id ] }
		@conversation = Conversation.new
	end 

	def create 
		@project = Project.find(params[:id])
		@conversation = Conversation.create(conversation_params.merge(:project_id => @project.id))
		@users = @project.users
		@conversation.users << current_user
		#redirect_to view_convo_path(@project, @conversation)
		redirect_to pick_convo_users_path(@conversation)
	end 

	def pick_users 
		#@project = Project.find(params[:id])
		@conversation = Conversation.find(params[:id])
		@project = @conversation.project
		existent_users = @conversation.users 
		@users = @project.users - existent_users
	end 

	def add_users
		#@project = Project.find(params[:project_id])
		@conversation = Conversation.find(params[:conversation_id])
		@user = User.find(params[:user_id]) 
		@conversation.users << @user
		redirect_to :back, notice: "#{@user.name} was successfully added to #{@conversation.name}"
	end 

	private 

	def conversation_params 
		params.require(:conversation).permit(:name)
	end 


end 