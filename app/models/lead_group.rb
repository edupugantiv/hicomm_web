class LeadGroup < Request
	scope :pending, -> { where(:pending => true) }
end