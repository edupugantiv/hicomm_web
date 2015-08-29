class UiController < ApplicationController

  def index
    @project = current_user.projects
  end

end