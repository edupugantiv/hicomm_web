class Conversation < ActiveRecord::Base
	has_and_belongs_to_many :users, join_table: "conversers"
	belongs_to :project
	has_many :messages

  after_create :assign_tag

  def assign_tag
    tags = %w(red green blue yellow purple teal white black orange pink grey maroon violet turquoise tan salmon plum orchid olive magenta lime ivory indigo gold fuchsia cyan azure lavender silver) - project.conversations.map(&:code)
    if tags.size == 0
      update(:code => '000')
    elsif project.conversations.size == 1
      update(:code => 'all')
    else
      update(:code => tags.sample)
    end
  end

end