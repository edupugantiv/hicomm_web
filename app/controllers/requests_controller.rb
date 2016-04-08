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
		@project = @request.project
		@group = @request.group

		if @request.type == 'JoinProject' 
			@project.users << @user
			@project.conversations.find_by(:name => "Project-Wide Conversation").users << @user
			@request.update_attributes(:pending => false)
		elsif @request.type == 'LeadProject'
			@project.update_attributes(:project_manager_id => @user.id)
			@request.update_attributes(:pending => false)
		elsif @request.type == 'JoinGroup' 
			@group.users << @user
			@request.update_attributes(:pending => false)
		elsif @request.type == 'LeadGroup' 
			@group.update_attributes(:group_manager_id => @user.id) 
			@request.update_attributes(:pending => false)
		elsif @request.type == 'NewUser'
			@user.update(is_active: true)
			@request.update_attributes(:pending => false)
		elsif @request.type == 'NewProject'
			@project.update(is_active: true)
			@request.update_attributes(:pending => false)
		elsif @request.type == 'NewGroup'
			@group.update(is_active: true)
			@request.update_attributes(:pending => false)
		end 
		redirect_to :back, notice: "Request Accepted"
	end 

	def decline 
		@request = Request.find(params[:id])
		@request.update_attributes(:pending => false)
		redirect_to :back, notice: "Request Declined"
	end 

	private 

	def request_params 
		params.require(:request).permit(:user_id, :group_id, :project_id, :type)
	end 

end 