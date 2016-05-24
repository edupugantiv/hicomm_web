class Schedule < ActiveRecord::Base
  belongs_to :subscription
  scope :not_finished, ->{ Schedule.all.where(:is_finished => false).where("date between ? and ?", DateTime.current - 2.hours, DateTime.current) }


end
