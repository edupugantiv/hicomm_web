class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def receive
    body = URI::decode_www_form(params[:data][:text])[0][0]
    project, conversation = nil, nil
    sender = User.find_by(:mobile => params[:data][:from][-10..-1])
    if !sender
      sender = User.find_by(:mobile => params[:data][:from][-9..-1])
    end
    strings = body.split(' ')
    remaining_body = []
    strings.each do |string|
      if string[0] == '@' and Project.find_by(:code => string[1..-1])
        project = string[1..-1]
      elsif string[0] == '#' and Conversation.find_by(:code => string[1..-1])
        conversation = string[1..-1]
      else
        remaining_body << string
      end
    end
    if project and conversation
      project = Project.find_by(:code => project)
      if project
        conversation = project.conversations.find_by(:code => conversation)
      end
    else
      project, conversation = nil, nil
    end

    if !sender or !project or !conversation or !project.conversations.include?(conversation)
      logger.debug "could not verify"
      logger.debug "sender: #{sender.id} project: #{project.id} conversation: #{conversation.id}"
      render :nothing => true and return
    end
    Message.create(
      :body => remaining_body.join(' '),
      :sent => Time.parse(params[:data][:timestamp]),
      :sender => sender,
      :conversation => conversation
    )
    render :nothing => true
  end

end