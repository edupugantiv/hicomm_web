class Conversation < ActiveRecord::Base
	has_and_belongs_to_many :users, join_table: "conversers"
	belongs_to :project
	has_many :messages

  after_create :assign_tag

  def assign_tag
    tag = Faker::Number.hexadecimal(3)
    while Conversation.find_by(:code => tag)
      tag = Faker::Number.hexadecimal(3)
    end
    update(:code => tag)
  end

end