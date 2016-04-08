class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!
  

  def index
    if current_user
      redirect_to '/home' and return
    end
    @user = User.new
  end

  def home 
    @user = current_user 
    @projects = @user.projects
    @conversations = @user.conversations 
    @groups = @user.groups
    @messages = []
    @conversations.each do |conversation|
      @messages += conversation.messages
    end 
    @lead_project_requests = LeadProject.where(:user_id => @user.id, :pending => true)
    @lead_group_requests = LeadGroup.where(:user_id => @user.id, :pending => true)
  end

  def search
    @results = []
    #if params[:search]
    @search_key = params[:search]
    @users = User.search(@search_key)#.order("created_at DESC")
    @projects = Project.search(@search_key)#.order("created_at DESC")
    @groups = Group.search(@search_key)#.order("created_at DESC")
    #else
      #@posts = Post.all.order('created_at DESC')
    #end
  end

  def notifications
    @user = current_user 
    @lead_project_requests = LeadProject.where(:user_id => @user.id, :pending => true)
    @lead_group_requests = LeadGroup.where(:user_id => @user.id, :pending => true)
    @projects = Project.where(:project_manager_id => @user.id)
    @groups = Group.where(:group_leader_id => @user.id)
    @join_project_requests = [] 
    @projects.each do |project| 
      @join_project_requests += project.requests.where(:type => 'JoinProject', :pending => true)
    end
    @join_group_requests = []
    @groups.each do |group|
      @join_group_requests += group.requests.where(:type => 'JoinGroup', :pending => true)
    end
  end

end