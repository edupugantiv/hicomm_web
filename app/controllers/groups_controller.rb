
class GroupsController < ApplicationController

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(params.require(:group).permit(:user_id, :name, :latitude, :longitude))
    if @group.save
      redirect_to 'home', notice: "Group created"
    else
      render :new, notice: "Group not created"
    end
  end

end
