class Post<ActiveRecord::Base 
	belongs_to :poster, :class_name => "User"
	belongs_to :group
end 