class Contact <ActiveRecord::Base
	#belongs_to :contact_a, :class_name => "User"
	#belongs_to :contact_b, :class_name => "User"
	belongs_to :user
	belongs_to :colleague, :class_name => "User"
end