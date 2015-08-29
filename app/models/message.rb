class Message <ActiveRecord::Base 
	belongs_to :conversation 
	belongs_to :sender, :class_name => "User"

  after_create :send_to_clickatell

  def send_to_clickatell

  end

end 