class LeadProject < Request
	scope :pending, -> { where(:pending => true) }
end