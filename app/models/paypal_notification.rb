class PaypalNotification < ActiveRecord::Base
  belongs_to :subscription
  scope :not_read, ->{ PaypalNotification.all.where(:is_read => false) }
end
