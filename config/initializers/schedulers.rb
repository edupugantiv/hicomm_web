require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '1h' do
	pending_shedules = Schedule.not_finished

	pending_shedules.each do |schedule|
		subscription_is_active = true
		subscription = Subscription.find(schedule.subscription_id)
		pending_paypal_notifications = PaypalNotification.not_read

		pending_paypal_notifications.each do |notification|
			
			if subscription_is_active == true
				if schedule.subscription_id == notification.subscription_id
					if notification.action == "suspend" || notification.action == "cancel"
						subscription.update(:is_active => false)
						subscription_is_active = false

						
						notification.update(:is_read => true)
					end
				end
			schedule.update(:is_finished => true)
			end
		end


		if subscription_is_active == true

			total_mc_gross = subscription.total_mc_gross + subscription.mc_gross
			total_mc_fee = subscription.total_mc_fee + subscription.mc_fee
			total_tax = subscription.total_tax + subscription.tax
			total_amount = subscription.total_amount + subscription.amount

			subscription.update(:total_amount => total_amount, :total_mc_gross => total_mc_gross, :total_mc_fee => total_mc_fee, :total_tax => total_tax)

			subscription.save

  		subscription.schedules.create(:date => 1.month.from_now, :is_finished => false)
		end

	end
end	