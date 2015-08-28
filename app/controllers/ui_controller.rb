class UiController

  def index
    @project = current_user.projects
  end

end