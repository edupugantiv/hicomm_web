class NewUser < Request
	scope :pending, -> { where(:pending => true) }
end 