class ConversationsController < ApplicationController
	before_action :authenticate_user!
	def show
		@conversation = Conversation.friendly.find(params[:id])
		@conversers = @conversation.users
		@message = Message.new
		@messages = @conversation.messages
		@project = @conversation.project
	end

	def new
		@project = Project.friendly.find(params[:id])
		#@users = @project.users.collect {|p| [ p.name, p.id ] }
		@conversation = Conversation.new
	end

	def create
		@project = Project.friendly.find(params[:id])
		@conversation = Conversation.create(conversation_params.merge(:project_id => @project.id))
		@users = @project.users
		@conversation.users << current_user
		#redirect_to view_convo_path(@project, @conversation)
		redirect_to pick_convo_users_path(@conversation)
	end

	def pick_users
		#@project = Project.find(params[:id])
		@conversation = Conversation.friendly.find(params[:id])
		@project = @conversation.project
		existent_users = @conversation.users
		@users = @project.users - existent_users
	end

	def add_users
		#@project = Project.find(params[:project_id])
		@conversation = Conversation.includes(:project).friendly.find(params[:conversation_id])
		@user = User.friendly.find(params[:user_id])
		@conversation.users << @user
		add_users_notification_to_user(@conversation, @user)
		redirect_to :back, notice: "#{@user.name} was successfully added to #{@conversation.name}"
	end


	private

	def conversation_params
		params.require(:conversation).permit(:name)
	end

  def add_users_notification_to_user(conversation, user)
  	message = "You have been added to conversation named #{conversation.name} in named <a href=#{project_path(conversation.project)}>#{conversation.project_name}</a>."
    Notification.send_notification(user, 'Added to Conversation', message)
  end


end