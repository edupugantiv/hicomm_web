class Notification < ActiveRecord::Base
	belongs_to :user
	scope :is_read, -> { where(:is_read => true) }
	scope :not_read, -> { where(:is_read => false) }
  paginates_per 6

	def self.send_notification(user, subject, message)
		user.notifications.create(:subject => subject, :body => message, :is_read => false)
	end
end
