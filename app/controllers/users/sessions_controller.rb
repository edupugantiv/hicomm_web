module Users
	class SessionsController < Devise::SessionsController

		def new
			redirect_to root_path
		end	

		def auth_options
  		{ scope: resource_name, recall: "welcome#index" }
		end

	end
end	