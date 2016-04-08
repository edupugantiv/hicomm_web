class GroupsController < ApplicationController
  #before_action :set_cart, only: [:show, :edit, :update,:destroy]
  before_action :authenticate_user!


  def new
    @group = Group.new
  end

  def index
    @groups = Group.all
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.create(group_params.merge(:group_leader_id => current_user.id))
    @group.users << current_user
    #redirect_to group_path(@group)
    if @group.save
      redirect_to group_path(@group), notice: "#{@group.name} was successfully created"
    else
      flash.now[:notice] = "Sorry, that group name is already taken"
      render new_group_path(@group), notice: "Sorry that group name is already taken"
    end
  end

  def edit 
    @group = Group.find(params[:id])
  end 

  def update
    @group = Group.find(params[:id]) 
    @group.update_attributes(group_params)
    redirect_to manage_group_path(@group), notice: "#{@group.name} has been updated"
  end  

  def show
    @group = Group.find(params[:id])
    @members = @group.users
    @posts = @group.posts
    @post = Post.new
    @projects = @group.projects
  end 

  def destroy
    @group = Group.find(params[:id])
    if @group.destroy
      redirect_to 'index', notice: "Left group"
    else
      render :new, notice: "Still in group"
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

  def pick_members
    @group = Group.find(params[:id])
    all_users = User.all
    existent_users = @group.users
    @users = all_users - existent_users
  end 

  def add_members
    @group = Group.find(params[:group_id])
    @user = User.find(params[:user_id])
    @group.users << @user
    redirect_to :back,  notice: "#{@user.name} was successfully added to #{@group.name}"
  end

  def remove_members
    @group = Group.find(params[:id])
    @members = @group.users - [@group.group_leader]
  end 

  def remove_member 
    @group = Group.find(params[:group_id])
    @user = User.find(params[:user_id])
    @group.users.delete(@user)
    redirect_to :back, notice: "#{@user.name} was successfully removed from #{@group.name}"
  end 

  def transfer_leadership
    @group = Group.find(params[:id])
    @members = @group.users - [current_user] 
  end 

  def new_leader
    @group = Group.find(params[:group_id])
    @user = User.find(params[:user_id])
    @request = Request.create(:group_id => @group.id, :user_id => @user.id, :pending => true, :type => 'LeadGroup')
    #@project.update_attributes(:project_manager_id => @user.id)
    redirect_to group_path(@group), notice: "leadership of #{@group.name} will be transfered to #{@user.name} upon approval"
  end 

  private 

  def group_params 
    params.require(:group).permit(:name, :location, :privacy, :scale, :avatar)
  end 

end
