Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :users 
  resources :conversations
  resources :messages
  resources :groups

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  get 'projects/new' => 'projects#new', as: 'new_project'
  post 'projects' => 'projects#create'

  get 'welcome/home' => 'welcome#home', as: 'welcome'
  get 'groups/home' => 'groups#index'
  get 'groups/new' => 'groups#new'
  put 'projects/:id/join' => 'projects#join', as: 'join'
  put 'projects/:id/leave' => 'projects#leave', as: 'leave'
  get 'projects/:id/conversations/new' => 'conversations#new', as: 'new_convo'
  post 'projects/:id/conversations/' => 'conversations#create', as: 'create_new_convo'
  get  'projects/:id/conversations/:id' => 'conversations#show', as: 'view_convo'
  get  'projects/:id/conversations/:id/pick_users' => 'conversations#pick_users', as: 'pick_convo_users'
  put  'projects/:id/conversations/:id/add_users/' => 'conversations#add_users', as: 'add_convo_users'

  get  'projects/:id/pick_users' => 'projects#pick_users', as: 'pick_project_users'
  put  'projects/:id/add_users/' => 'projects#add_users', as: 'add_project_users'

  post 'messages/create' => 'messages#create', as: 'post_new_message'
  get 'projects/:project_id/show/:conversation_id' => 'projects#show', as: 'project'

  get 'search' => 'welcome#search', as: 'search'

  get 'users/:id/manage' => 'users#manage', as: 'manage_user'

  get 'projects/:id/manage' => 'projects#manage_participants', as: 'manage_project'
  get 'projects/:id/remove_participants' => 'projects#remove_participants', as: 'remove_project_participants'
  put 'projects/:id/remove' => 'projects#remove_participant', as: 'remove_project_participant'
  get 'projects/:id/transfer_leadership' => 'projects#transfer_leadership', as: 'transfer_project_leadership'
  post 'projects/:id/new_leader' => 'projects#new_leader', as: 'new_leader'

  post 'requests' => 'requests#create', as: 'create_request'

  put 'requests/:id/approve' => 'requests#approve', as: 'approve_request'
  put 'requests/:id/decline' => 'requests#decline', as: 'decline_request'
  
  get 'projects/:id/add_affiliations' => 'projects#add_affiliations', as: 'add_affiliations'
  put 'projects/:id/affiliate' => 'projects#affiliate', as: 'affiliate'

  put 'users/:id/add_contact' => 'users#add_colleague', as: 'add_contact'
  put 'users/:id/remove_contact' => 'users#remove_colleague', as: 'remove_contact'

  put 'groups/:id/join' => 'groups#join', as: 'join_group'
  put 'groups/:id/leave' => 'groups#leave', as: 'leave_group'

  get 'groups/:id/manage' => 'groups#manage_members', as: 'manage_group'

  get  'groups/:id/pick_members' => 'groups#pick_members', as: 'pick_group_members'
  put  'groups/:id/add_members/' => 'groups#add_members', as: 'add_group_members'
  get 'groups/:id/remove_members' => 'groups#remove_members', as: 'remove_group_members'
  put 'groups/:id/remove_member' => 'groups#remove_member', as: 'remove_group_member'
  get 'groups/:id/transfer_leadership' => 'groups#transfer_leadership', as: 'transfer_group_leadership'
  post 'groups/:id/new_leader' => 'groups#new_leader', as: 'new_group_leader'

  get 'conversations/:id/posts/new' => 'posts#create', as: 'new_post'
  post 'conversations/:id/posts' => 'posts#create', as: 'create_post'

  get 'notifications' => 'welcome#notifications', as: 'notifications'

  #put  'projects/:id/conversations/:id' => 'conversations#update', as: 'update_convo'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
