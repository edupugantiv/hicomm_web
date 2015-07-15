class RequestsController <ApplicationController 
	def new 
		@request = Request.new
	end 

	def create 
		@request = Request.create(request_params.merge(:pending => true))
	end 

	def approve
		@request = Request.find(params[:id])
		@user = @request.user
		if @request.type == 'JoinProject' 
			@request.project.users << @user
			@request.update_attributes(:pending => false)
		elsif @request.type == 'LeadProject'
			@request.project.update_attributes(:project_manager_id => @user.id)
			@request.update_attributes(:pending => false)
		elsif @request.type == 'JoinGroup' 
			@request.group.users << @user
			@request.update_attributes(:pending => false)
		else 
			@request.group.update_attributes(:group_manager_id => @user.id) 
			@request.update_attributes(:pending => false)
		end 
		redirect_to :back, notice: "Request Accepted"
	end 

	def decline 
		@request = Request.find(params[:id])
		@request.update_attributes(:pending => false)
	end 

	private 

	def request_params 
		params.require(:request).permit(:user_id, :group_id, :project_id, :type)
	end 

end 