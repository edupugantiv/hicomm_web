class UiController < ApplicationController

  def index
  	if current_user.is_admin?
  		@requests = Request.where(:pending => true)
  		@join_project_requests = Request.where(:pending => true, :type => 'JoinProject')
  		@join_group_requests = Request.where(:pending => true, :type => 'Joingroup')
  		@lead_project_requests = Request.where(:pending => true, :type => 'LeadProject')
  		@lead_group_requests = Request.where(:pending => true, :type => 'LeadGroup')
  		@new_user_requests = Request.where(:pending => true, :type => 'NewUser')
  		@new_project_requests = Request.where(:pending => true, :type => 'NewProject')
  		@new_group_requests = Request.where(:pending => true, :type => 'NewGroup')
	else
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

end