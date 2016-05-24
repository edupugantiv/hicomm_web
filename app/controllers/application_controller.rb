class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :notification_count
  helper_method :total_requests_count
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_cache_buster

  layout :layout_by_resource

  protected

  def notification_count
    a = current_user.notifications.not_read.size
  end

  def total_requests_count
    if !current_user.is_admin?
      current_user.total_requests_count
    end
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
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :location, :country, :job, :mobile, :email, :password, :password_confirmation, :privacy) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:mobile, :password) }
  end

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
  end

end