class JoinGroup < Request
  scope :pending, -> { where(:pending => true) }

  def self.requests_sent_by_user(user_id, group_id)
  	self.pending.where(:request_by => user_id, :group_id => group_id)
  end
end