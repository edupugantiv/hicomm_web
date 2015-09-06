class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    puts params[:data][:text]
  end

end