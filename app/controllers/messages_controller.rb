class MessagesController < ApplicationController 
	before_action :authenticate_user!
	def new 
		@message = Message.new
	end 

	def create
		@conversation = Conversation.find(params[:id])
		@message = Message.create(message_params.merge(:sender_id => current_user.id, :conversation_id => @conversation.id, :sent => Time.now))
		redirect_to :back
	end 

	def show
		@conversation = Conversation.find(params[:id])
		@messages = @conversation.messages
	end 

	private 

	def message_params 
		params.require(:message).permit(:body)
	end 

end 