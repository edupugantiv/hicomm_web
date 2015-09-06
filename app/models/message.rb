class Message <ActiveRecord::Base 
	belongs_to :conversation 
	belongs_to :sender, :class_name => "User"

  after_create :send_to_clickatell

  def send_to_clickatell
    conversation.users.each do |user|
      if user != sender
        Curl.get('http://api.clickatell.com/http/sendmsg', {
          :user => 'youngsu',
          :password => 'GodBless15',
          :api_id => user.country == 'USA' ? 3559754 : 3549952,
          :from => user.country == 'USA' ? 12134585108 : 44760,
          :MO => 1,
          :to => user.full_number,
          :text => full_body
        })
      end
    end
  end

  def full_body
    "#{body} REPLY @#{conversation.project.code} \##{conversation.code}"
  end

end 