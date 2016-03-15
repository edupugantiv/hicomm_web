class UiController < ApplicationController

  def index
    @projects = current_user.projects.includes(:conversations)
    @groups = current_user.groups
    @suggested_groups = Group.all - @groups
	
	if !params[:conversation_id].nil?
		@current_conversation = Conversation.find(params[:conversation_id])
		@project = @current_conversation.project
		@message = Message.new
	end 

  end

end