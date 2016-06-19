module Users
	class SessionsController < Devise::SessionsController
	  before_action :check_user_status, only: [:create]

		def new
			redirect_to root_path
		end	

		def auth_options
  		{ scope: resource_name, recall: "welcome#index" }
		end

  def check_user_status
    user = User.find_by(mobile: params[:user][:mobile])
    if !user.nil?
      if !user.is_active
        if current_user
          sign_out current_user
        end
        redirect_to new_user_session_path, notice: 'Sorry for inconvenience, your account has been deactivated,
                                                    please contact our support for further process.'
      end
    else
      redirect_to new_user_session_path, notice: 'Invalid Mobile or Password'
    end
  end

	end
end	