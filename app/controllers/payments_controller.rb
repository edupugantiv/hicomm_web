class PaymentsController <ApplicationController

  protect_from_forgery except: [:paypal_hook, :paypal_notification]
  before_action :authenticate_user!, except: [:paypal_hook, :paypal_notification]

	before_filter :check_if_payment_already_made, only:[:pay]

  def pay
		@project = Project.friendly.find(params[:id])
		@card = Card.new
	end

 	def pay_amount
 		@project = Project.includes(:subscriptions).friendly.find(params[:id])
    return_path = project_path(@project.id)
    if @project.subscriptions.blank?
      subscription = @project.subscriptions.create()
    end

    redirect_to @project.paypal_url(return_path)
  end

  def paypal_hook
  	if params[:txn_type] == "subscr_payment"
      if !PaypalNotification.where(:action => 'create').pluck(:ipn_track_id).include? params[:ipn_track_id]
        project = Project.includes(:users, :subscriptions).friendly.find(params[:invoice])
        mc_fee = params[:mc_fee].to_f
        mc_gross = params[:mc_gross].to_f
        tax = params[:tax].to_f
        amount = mc_gross - mc_fee - tax
        is_active = (params[:payment_status] == "Completed") ? true :false
        user_id = project.project_manager.id

        subscription = project.subscriptions.last
        subscription.update(:plan => project.plan, :payer_email => params[:payer_email], :payer_id => params[:payer_id], :is_through_card => false,
          :is_recurring => true, :transaction_id => params[:transaction_id], :profile_id => params[:subscr_id], :cycle_count => 1,
          :payment_status => params[:payment_status], :is_success => true, :amount => amount, :mc_gross => mc_gross, :mc_fee => mc_fee, :tax => tax,
          :total_amount => amount, :total_mc_gross => mc_gross, :total_mc_fee => mc_fee, :total_tax => tax, :is_active => is_active, :user_id => user_id)

        subscription.paypal_notifications.create(:action => 'create', :ipn_track_id => params[:ipn_track_id], :profile_id => params[:recurring_payment_id], :is_read => false)
    		subscription.schedules.create(:date => 1.month.from_now, :is_finished => false)

        send_project_payment_success_notification(project)

  		elsif params[:txn_type].include? 'suspended'
  			subscription = Subscription.find_by_profile_id(params[:recurring_payment_id])
  			subscription.paypal_notifications.create(:action => 'suspend', :ipn_track_id => params[:ipn_track_id], :profile_id => params[:recurring_payment_id], :is_read => false)

  		elsif params[:txn_type].include? 'cancel'
  			subscription = Subscription.find_by_profile_id(params[:recurring_payment_id])
  			subscription.paypal_notifications.create(:action => 'cancel', :ipn_track_id => params[:ipn_track_id], :profile_id => params[:recurring_payment_id], :is_read => false)
      end
  	end
  	render nothing: true
  end

  def paypal_notification
		if params[:txn_type].include? 'suspended'
			subscription = Subscription.find_by_profile_id(params[:recurring_payment_id])
			subscription.paypal_notifications.create(:action => 'suspend', :ipn_track_id => params[:ipn_track_id], :profile_id => params[:profile_id], :is_read => false)
  	end
  	render nothing: true
	end

  def check_if_payment_already_made

    @project = Project.friendly.find(params[:id])
    paid = false
    @project.subscriptions.each do |subscription|
      if subscription.is_active?
        paid = true
      end
    end
    if paid == true
      redirect_to project_path(@project), alert: 'Payment already made for the project'
    elsif Project.paid.last.include? @project
      if current_user.managed_projects.include? @project
        redirect_to home_path, alert: "We still didn't get a payment confirmation of #{@project.name} from PayPal. So please come back after some time."
      else
        redirect_to home_path, alert: 'You do not have access to this path'
      end
    elsif !(current_user.managed_projects.include? @project)
      redirect_to home_path, :alert => 'You do not have access to this project'
    end

  end

  def send_project_payment_success_notification(project)
    message_to_user = "Payment for the project <a href=#{project_path(project)}>#{project.name}</a> is successfully completed.
     You can access the project from now."
    message_to_admin = "Payment for the project <a href=#{project_path(project)}>#{project.name}</a> is successfully paid by
     <a href=#{user_path(project.project_manager)}>."

    admin  = Admin.first

    Notification.send_notification(project.project_manager, 'Payment Success', message_to_user)
    Notification.send_notification(admin, 'Payment Success', message_to_admin)
  end
end
