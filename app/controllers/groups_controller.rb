class GroupsController < ApplicationController

  before_action :authenticate_user!

  def new
    @group = Group.new
  end

  def index
    @groups = Group.all
  end

  def create
    @group = Group.new(params.require(:group).permit(:name, :latitude, :longitude).merge(:group_leader_id => current_user.id))
    @group.users << current_user
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

  def join 
    @group = Group.find(params[:id])
    # @project.users << current_user 
    @request = Request.create(:group_id => @group.id, :user_id => current_user.id, :pending => true, :type => 'JoinGroup')
    redirect_to :back, notice: "Your request to join #{@group.name} has been sent"
  end 

  def leave 
    @group = Group.find(params[:id])
    @group.users.delete(current_user)
    redirect_to :back, notice: "You have left #{@group.name}"
  end 

  def manage_members
    @group = Group.find(params[:id])
    @members = @group.users 
    @requests = JoinGroup.where(:group_id => @group.id, :pending => true)
  end 
end
