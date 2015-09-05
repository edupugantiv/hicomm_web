class ApiController < ApplicationController

  def receive
    puts params
    puts JSON.parse(params)
  end
  
end