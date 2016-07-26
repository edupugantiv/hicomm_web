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
    @messages.each do |message|
      message.mark_as_read! :for => current_user
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

  # def notifications
  #   @user = current_user
  #   @lead_project_requests = LeadProject.where(:user_id => @user.id, :pending => true)
  #   @lead_group_requests = LeadGroup.where(:user_id => @user.id, :pending => true)
  #   @projects = Project.where(:project_manager_id => @user.id)
  #   @groups = Group.where(:group_leader_id => @user.id)
  #   @join_project_requests = []
  #   @projects.each do |project|
  #     @join_project_requests += project.requests.where(:type => 'JoinProject', :pending => true)
  #   end
  #   @join_group_requests = []
  #   @groups.each do |group|
  #     @join_group_requests += group.requests.where(:type => 'JoinGroup', :pending => true)
  #   end
  # end


  def contact_us
    @user = User.new
  end

  def about_us
  end

  def plan
  end

  def send_authentication_code
    country_code = params[:countryCode]
    phone_number = params[:phoneNumber]
    code = Faker::Number.hexadecimal(6)
    number = country_code+phone_number
    # number = 918686638646

    if phone_number.length == 10
      authentication_code = AuthenticationCode.create(phone_number: number, code: code)

      clickatell_response = Curl.get('http://api.clickatell.com/http/sendmsg', {
        :user => 'hihihihi',
        :password => 'FKXeNCeXfTcZfZ',
        # :api_id => user.country == 'USA' ? 3559754 : 3549952,
        :api_id => 3599889,
        # :from => user.country == 'USA' ? 12134585108 : 44760,
        :MO => 1,
        :to => number,
        :text => 'Hi your authentication code for clickatell is #{code}. Please enter this to continue.'
      })

      authentication_code.update(clickatell_message_id: clickatell_response.body)

      render :json => {
        :status => 'success'
      }
    else
      render :json => {
        :status => 'failure',
        :message => 'Please enter a valid phone number.'
      }
    end


  end

  def authenticate_code
    country_code = params[:countryCode]
    phone_number = params[:phoneNumber]
    code = params[:code]
    number = country_code+phone_number
    # number = 918686638646

    authentication_code = AuthenticationCode.where(phone_number: number).last
    if authentication_code.code  == code
      render :json => {
        :status => 'success'
      }

    else
      render :json => {
        :status => 'failure',
        :message => 'Wrong code. Please try again.'
      }

    end
  end
end