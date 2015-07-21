class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :notification_count

  protected

  def notification_count 
  	@user = current_user
  	@lead_project_requests = LeadProject.where(:user_id => @user.id, :pending => true)
	@lead_group_requests = LeadGroup.where(:user_id => @user.id, :pending => true)
	@projects = Project.where(:project_manager_id => @user.id)
	@groups = Group.where(:group_leader_id => @user.id)
	@join_project_requests = [] 
	@projects.each do |project| 
		@join_project_requests += project.requests.where(:type => 'JoinProject', :pending => true)
	end 
	@join_group_requests = []
	@groups.each do |group|
		@join_group_requests += group.requests.where(:type => 'JoinGroup', :pending => true)
	end 
	@notifications = @lead_project_requests + @lead_group_requests + @join_project_requests + @join_group_requests
	return @notifications.size
  end 
end
