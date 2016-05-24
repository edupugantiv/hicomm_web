class Subscription < ActiveRecord::Base
	belongs_to :user
	belongs_to :project

	has_many :cards
	has_many :schedules
	has_many :paypal_notifications
end
