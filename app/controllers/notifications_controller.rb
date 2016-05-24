class NotificationsController < ApplicationController

	def index
		@notifications = current_user.notifications.order(created_at: :desc).page params[:page]
	end

	def mark_as_read
		notification_id = params[:notification_id]

		notification = Notification.find(notification_id)
		notification.update(is_read: true)
    render :json => {
      :status => 'success'
    }
	end

	def mark_all_as_read
		current_user.notifications.not_read.update_all(is_read: true)
    render :json => {
      :status => 'success'
    }
	end

end