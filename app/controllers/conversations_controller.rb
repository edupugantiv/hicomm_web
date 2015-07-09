class ConversationsController < ApplicaitonController 
	before_action :authenticate_user!
	def show 
		@conversation = Conversation.find(params[:id])
	end 

	def new 
		@conversation = Conversation.new
	end 

	def create 
		@conversation = Conversation.create(conversation_params)
	end 

	private 

	def conversation_params 
		params.require(:conversation).permit(:name, :project_id)
	end 


end 