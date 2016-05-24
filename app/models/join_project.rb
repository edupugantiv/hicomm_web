class JoinProject < Request
	scope :pending, -> { where(:pending => true) }
end 