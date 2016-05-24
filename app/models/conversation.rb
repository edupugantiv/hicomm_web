class Conversation < ActiveRecord::Base
	has_and_belongs_to_many :users, join_table: "conversers"
	belongs_to :project
	has_many :messages
  delegate :code, :name, :to => :project, :prefix => true


  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  after_create :assign_tag

  def assign_tag
    tags = %w(red green blue yellow purple teal orange pink grey maroon violet turquoise salmon plum orchid olive magenta lime indigo gold fuchsia cyan azure lavender silver) - project.conversations.map(&:code)
    if tags.size == 0
      update(:code => '000')
    elsif project.conversations.size == 1
      update(:code => 'all')
    else
      update(:code => tags.sample)
    end
  end

  private
    def slug_candidates
      project = self.project.slug
      [
        :name,
        [:name, :code],
        [:name, :code, :project]
      ]
    end


end