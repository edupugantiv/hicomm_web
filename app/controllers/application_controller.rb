class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :notification_count
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  layout :layout_by_resource
  

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

  def check_current_user
    if current_user.nil?
      redirect_to root_path
    end  
  end

  def layout_by_resource
    if current_user.nil?
      "home"
    else
      "application"
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :location, :country, :job, :mobile, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:mobile, :password) }
  end
end
