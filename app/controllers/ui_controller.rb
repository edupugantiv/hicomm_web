class UiController < ApplicationController

  def index
  	if current_user.is_admin?
  		@requests = current_user.requests_by_me
  		@new_user_requests = NewUser.pending
  		@new_project_requests = NewProject.pending
  		@new_group_requests = NewGroup.pending
  		
	else
	    @projects = current_user.projects.includes(:conversations, :messages).first(4)
	    @total_groups = current_user.groups.includes(:users)
	    @suggested_group = (Group.all - @total_groups - Group.where(privacy: 'private')).first
	    @groups = @total_groups.first(4)

		if !params[:conversation_id].nil?
			@current_conversation = Conversation.includes(:project, :users, :messages).friendly.find(params[:conversation_id])
			@messages = @current_conversation.messages.includes(:sender)
			@project = @current_conversation.project
			@message = Message.new
		end
  	end
  end
end