class Card < ActiveRecord::Base

  belongs_to :subscription
  validates :cvc, :numericality => {:only_integer => true}
  validates :card_number, :numericality => {:only_integer => true}

  def purchase(project_name, user_name)
    response = GATEWAY.recurring(price_in_cents, credit_card, purchase_options(user_name, project_name))
  end

  def price_in_cents
  	# (self.subscription.project.scale.price)*100
    100
  end

  private

  def purchase_options(user_name, project_name)
    values = {
            ip: ip_address,
        period: 'Month',
        frequency: 1,
        cycles: 50,
        description: project_name,
        start_date: Time.now
      }
  end

  def validate_card
    if credit_card.valid?
      self.save
      true
    else
      credit_card.errors.full_messages.each do |message|
        errors.add :base, message
      end
      false
    end
  end

  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
        brand:               self.card_type,
        number:              self.card_number,
        verification_value:  self.cvc,
        month:               self.expiry_month,
        year:                self.expiry_year,
        first_name:          self.name,
        last_name:           ''
    )
  end
end
