class MessageRead < ActiveRecord::Base
  belongs_to :message
  belongs_to :user

  delegate :first_name, :to => :user, :prefix => true

end
