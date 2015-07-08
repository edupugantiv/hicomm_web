class MessagesController < ApplicationController 
	before_action :authenticate_user
	def new 
		@message = Message.new
	end 

	def create
		@messag = Message.create(message_params)
	end 

	private 

	def message_params 
		params.require(:message).permit(:body, :sent, :conversation_id, :sender_id)
	end 

end 