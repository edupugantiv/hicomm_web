class DashboardController < ApplicationController
  before_action :set_project

  def messages
    data = {}
    case params[:time]
    when 'week'
      messages = @messages.where(:sent => 7.days.ago..Time.now)
      7.times do |i|
        data[i.days.ago.yday] = {
          :label => i.days.ago.strftime('%b %-d'),
          :count => messages.where(:sent => (i + 1).days.ago..i.days.ago).count
        }
      end
    when 'month'
      messages = @messages.where(:sent => 4.weeks.ago..Time.now)
      4.times do |i|
        data[i.weeks.ago.yday] = {
          :label => "#{i} week(s) ago",
          :count => messages.where(:sent => (i + 1).weeks.ago..i.weeks.ago).count
        }
      end
    when 'year'
      messages = @messages.where(:sent => 11.months.ago..Time.now)
      11.times do |i|
        data[i.months.ago.month] = {
          :label => i.months.ago.strftime('%b %Y'),
          :count => messages.where(:sent => (i + 1).months.ago..i.months.ago).count
        }
      end
    end
    counts = []
    labels = []
    data.keys.each do |key|
      labels << data[key][:label]
      counts << data[key][:count]
    end
    render :json => {
      :labels => labels.reverse,
      :counts => counts.reverse
    }
  end

  def equity
    users = @messages.map(&:sender).uniq.map do |user|
      {
        :value => @messages.where(:sender => user).count,
        :label => user.name
      }
    end
    render :json => users
  end

  def cloud
    messages = Hash.new(0)
    @messages.each do |message|
      articles = /\b(?:#{ %w[to and or the a].join('|') })\b/i
      message.body.downcase.gsub(/[^a-z0-9\s]/i, ' ').gsub(articles, '').split(' ').each do |word|
        messages[word] += 1
      end
    end
    data = messages.keys.map do |key|
      {
        :text => key,
        :weight => messages[key]
      }
    end
    render :json => data
  end

  private

  def set_project
    @project = Project.find(params[:id])
    case params[:conversation]
    when 'all'
      @messages = @project.messages
    else
      @messages = @project.conversations.find(params[:conversation]).messages
    end
  end

end