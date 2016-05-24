class CardsController < ApplicationController

	def create
		project = Project.friendly.find(params[:format])
		project_name = project.name
		user_name = current_user.name
		params[:cvc].to_i
		params[:card_number].to_i

		card =	Card.create(card_params)

		response =	card.purchase(project_name, user_name)

    	if response.success?
	  		mc_fee = params[:mc_fee].to_f
	  		mc_gross = params[:mc_gross].to_f
	  		tax = params[:tax].to_f
	  		amount = mc_gross - mc_fee - tax
	  		is_active = (params[:payment_status] == "Completed") ? true :false
	  		user_id = project.project_manager.id

    	
    		subscription = project.subscriptions.create(:plan => project.plan, :payer_email => params[:payer_email], :payer_id => params[:payer_id], :is_through_card => true,
  			:is_recurring => true, :transaction_id => params[:transaction_id], :profile_id => params[:subscr_id], :cycle_count => 1,
  			:payment_status => params[:payment_status], :is_success => true, :amount => amount, :mc_gross => mc_gross, :mc_fee => mc_fee, :tax => tax,
  			:total_amount => amount, :total_mc_gross => mc_gross, :total_mc_fee => mc_fee, :total_tax => tax, :is_active => is_active, :user_id => user_id)
	 		subscription.save

  		subscription.schedules.create(:date => 1.month.from_now, :is_finished => false)
      else
        redirect_to :back, alert: response.message
      end
	end

	def card_params
		params.require(:card).permit(:subscription_id, :name, :card_type, :expiry_month, :expiry_year, :card_number, :cvc, :ip_address)
	end	
end