class NewGroup < Request
	scope :pending, -> { where(:pending => true) }
end 