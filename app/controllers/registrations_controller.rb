class RegistrationsController < Devise::RegistrationsController 

	private 

	def sign_up_params 
		params.require(:user).permit(:name, :location, :job, :mobile, :email, :password, :password_confirmation, :privacy, :terms_of_use)
	end 

	def account_update_params 
		params.require(:user).permit(:name, :location, :job, :mobile, :email, :password, :password_confirmation, :current_password, :privacy)
	end 

end 