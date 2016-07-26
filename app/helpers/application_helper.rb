module ApplicationHelper
	def other_users(message, conversation_users)
		users = conversation_users.where.not(id: message.sender.id)
	end
end
