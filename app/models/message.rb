class Message <ActiveRecord::Base 
	belongs_to :conversation 
	belongs_to :sender, :class_name => "User"

  # after_create :send_to_clickatell

  def send_to_clickatell
    conversation.users.each do |user|
      if user != sender
        Curl.get('http://api.clickatell.com/http/sendmsg', {
          :user => 'youngsu',
          :password => 'GodBless15',
          :api_id => user.country == 'USA' ? 3559754 : 0,
          :from => user.country == 'USA' ? 12134585108 : 0,
          :MO => 1,
          :to => user.full_number,
          :text => body
        })
        Curl.get('http://api.clickatell.com/http/sendmsg?user=Youngsu&password=GodBless15&api_id=3559754&from=12134585108&MO=1&to=17036221005&text=%22this%20is%20from%20the%20internet%22')
      end
    end
  end

end 