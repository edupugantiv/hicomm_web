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

    can :add_colleague, User
    #A user cannot add someone that is already their contact
    cannot :add_colleague, User, :colleagues => {:id => user.id}

    can [:read, :approve, :decline], Request, :project => {:project_manager_id => user.id}

    #A user can start a conversation that belongs to a project they are part of
    can [:create, :add_users, :update], Conversation, :project => { :users => {:id => user.id} }

    can [:update, :destroy, :pick_users, :add_users, :transfer_leadership], Group, :group_leader_id => user.id

    can [:read, :create], Group
    # A member of a Project cannot join a project
    cannot :join, Group, :users => {:id => user.id}
    # A participant can leave a group
    can :leave, Group, :users => {:id => user.id}
  end
end
