class NewProject < Request
	scope :pending, -> { where(:pending => true) }
end 