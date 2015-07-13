class GroupsController < ApplicationController

  before_action :authenticate_user!

  def new
    @group = Group.new
  end

  def index
    @groups = Group.all
  end

  def create
    @group = Group.new(params.require(:group).permit(:user_id, :name, :latitude, :longitude))
    if @group.save
      redirect_to 'home', notice: "Group created"
    else
      render :new, notice: "Group not created"
    end
  end

  def show
    @group = Group.find(params[:id])
  end 

  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
