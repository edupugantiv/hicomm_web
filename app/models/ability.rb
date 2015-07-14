class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new 
    # All Users can view a Project 
    can [:read, :create], Project 
    # A member of a Project cannot join a project 
    cannot :join, Project, :users => {:id => user.id}
    # A participant can leave a group 
    can :leave, Project, :users => {:id => user.id}
    # A project manager can update, destroy, pick and add users, and transfer leadership
    can [:update, :destroy, :pick_users, :add_users, :transfer_leadership], Project, :project_manager_id => user.id 


    #A user can manage their own profile
    can :update, User, :id => user.id 
    #A user cannot add someone that is already their contact 
    cannot :remove_contact, User, :contacts => {:id => user.id}

    #A user can start a conversation that belongs to a project they are part of 
    #can [:create, :add_users, :update], Conversation, :project => :users => {:id => user.id}


    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
