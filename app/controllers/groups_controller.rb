class GroupsController < ApplicationController
  before_filter :check_group_leader, except: [:index, :show, :new, :create, :join, :leave]
  before_action :authenticate_user!

  def new
    @group = Group.new
  end

  def index
    # @groups = current_user.groups.includes(:group_leader, :projects)
    @groups = current_user.groups.includes(:group_leader, :projects).order(:name).page params[:page]
  end

  def create
    @group = Group.create(group_params.merge(:group_leader_id => current_user.id))
    @group.users << current_user
    #redirect_to group_path(@group)
    if @group.save
      group_create_notifications(@group)
      redirect_to group_path(@group), notice: "#{@group.name} was successfully created"
    else
      flash.now[:alert] = "Sorry, that group name is already taken"
      render new_group_path(@group), alert: "Sorry that group name is already taken"
    end
  end

  def edit
    @group = Group.friendly.find(params[:id])
  end

  def update
    @group = Group.friendly.find(params[:id])
    @group.update_attributes(group_params)
    redirect_to manage_group_path(@group), notice: "#{@group.name} has been updated"
  end

  def show
    @group = Group.includes(:projects, :users, :posts).friendly.find(params[:id])
    @members = @group.users.limit(4)
    @projects = @group.projects.limit(4)
    @posts = @group.posts
    @requests_sent_by_user = JoinGroup.requests_sent_by_user(current_user.id, @group.id)
    @join_request_sent = !@requests_sent_by_user.blank?
    @post = Post.new
  end

  def destroy
    @group = Group.friendly.find(params[:id])
    if @group.destroy
      redirect_to 'index', notice: "Left group"
    else
      render :new, notice: "Still in group"
    end
  end

  def list_of_users
    @group = Group.includes(:users).friendly.find(params[:id])
    @users = @group.users
    @user_count = @users.size
  end

  def associated_projects
    @group = Group.includes(:projects).friendly.find(params[:id])
    @projects = @group.projects
    @project_count = @projects.size
  end

  def join
    @group = Group.friendly.find(params[:id])
    # @project.users << current_user
    @request = Request.create(:group_id => @group.id, :user_id => current_user.id,
      :request_by => current_user.id, :request_to => @group.group_leader_id, :pending => true, :type => 'JoinGroup')

    if @request.save!
       group_join_request_notifications(@group)
    end

    redirect_to :back, notice: "Your request to join #{@group.name} has been sent"
  end

  def leave
    @group = Group.friendly.find(params[:id])
    @group.users.delete(current_user)
    leave_notification(@group, current_user)
    redirect_to :back, notice: "You have left #{@group.name}"
  end

  def manage_members
    @group = Group.friendly.find(params[:id])
    @members = @group.users
    @requests = JoinGroup.includes(:user).where(:group_id => @group.id, :pending => true)
  end

  def pick_members
    @group = Group.friendly.find(params[:id])
    all_users = User.all
    existent_users = @group.users
    @users = all_users - existent_users
  end

  def add_members
    @group = Group.friendly.find(params[:group_id])
    @user = User.friendly.find(params[:user_id])
    @group.users << @user
    add_members_notification_to_user(@group, @user)
    redirect_to :back,  notice: "#{@user.name} was successfully added to #{@group.name}"
  end

  def remove_members
    @group = Group.friendly.find(params[:id])
    @members = @group.users - [@group.group_leader]
  end

  def remove_member
    @group = Group.friendly.find(params[:group_id])
    @user = User.friendly.find(params[:user_id])
    @group.users.delete(@user)
    remove_members_notification_to_user(@group, @user)

    redirect_to :back, notice: "#{@user.name} was successfully removed from #{@group.name}"
  end

  def transfer_leadership
    @group = Group.friendly.find(params[:id])
    @members = @group.users - [current_user]
  end

  def new_leader
    @group = Group.friendly.find(params[:group_id])
    @user = User.friendly.find(params[:user_id])
    @request = Request.create(:group_id => @group.id, :user_id => @user.id, :request_to => @user.id,
     :request_by => @group.group_leader_id, :pending => true, :type => 'LeadGroup')

    group_new_leader_notifications(@group, @user)

    #@project.update_attributes(:project_manager_id => @user.id)
    redirect_to group_path(@group), notice: "leadership of #{@group.name} will be transfered to #{@user.name} upon approval"
  end

  private

  def check_group_leader
    group = Group.friendly.find(params[:id])
    if current_user.managed_groups.include? group
      true
    else
      redirect_to group_path(group), notice: "Sorry, you cannot access this path."
    end
  end

  def group_params
    params.require(:group).permit(:name, :location, :privacy, :scale, :avatar)
  end

  def group_join_request_notifications(group)
    message_to_group_leader = "<a href=#{user_path(current_user)}>#{current_user.name.capitalize}</a> has requested
      to join the group <a href=#{group_path(group)}>#{group.name}</a>. Please go to this
       <a href=#{requests_path}>link</a> to approve it."
    message_to_user = "Your request has been successfully placed to join the
       group <a href=#{group_path(group)}>#{group.name}</a>."

    Notification.send_notification(group.group_leader, 'Join Group', message_to_group_leader)
    Notification.send_notification(current_user, 'Join Group', message_to_user)
  end


  def group_create_notifications(group)
    message_to_group_leader = "You have successfully created a new group named
       <a href=#{group_path(group)}>#{group.name}</a>."
    message_to_admin = "A new group named <a href=#{group_path(group)}>#{group.name}</a> is created.
     Please go to this <a href=#{requests_path}>link</a> to approve it."
    admin = Admin.first

    Notification.send_notification(admin, 'New Group Created', message_to_admin)
    Notification.send_notification(group.group_leader, 'New Group Created', message_to_group_leader)
  end

  def group_new_leader_notifications(group, user)
    message_to_group_leader = "You have successfully requested <a href=#{user_path(user)}>#{user.name}</a>
       to lead group named <a href=#{group_path(group)}>#{group.name}</a>."
    message_to_user = "<a href=#{user_path(group.group_leader)}>#{group.group_leader.name.capitalize}</a>
      has requested you to lead group named <a href=#{group_path(group)}>#{group.name}</a>.
      Please go to this <a href=#{requests_path}>link</a> to approve it."
    Notification.send_notification(user, 'New Group Leader Request', message_to_user)
    Notification.send_notification(group.group_leader, 'New Group Leader Request', message_to_group_leader)
  end

  def add_members_notification_to_user(group, user)
    message = "You have been added to group named <a href=#{group_path(group)}>#{group.name}</a>."
    Notification.send_notification(user, 'Added to Group', message)
  end

  def remove_members_notification_to_user(group, user)
    message = "You have been removed from group named <a href=#{group_path(group)}>#{group.name}</a>."
    Notification.send_notification(user, 'Removed from Group', message)
  end

  def leave_notification(group, user)
    message_to_user = "You have left group named <a href=#{group_path(group)}>#{group.name}</a>."
    message_to_group_leader = " <a href=#{user_path(current_user)}>#{current_user.name.capitalize}</a> has left group named <a href=#{group_path(group)}>#{group.name}</a>."

    Notification.send_notification(user, 'Left from Group', message_to_user)
    Notification.send_notification(group.group_leader, 'Left from Group', message_to_group_leader)
  end

end
