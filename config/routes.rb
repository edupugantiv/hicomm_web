Rails.application.routes.draw do
  get 'errors/not_found'

  get 'errors/internal_server_error'

  devise_for :users, :controllers => { :sessions => "users/sessions", :registrations => "users/registrations"}

  
  resources :users, only: [:show, :edit, :update]
  resources :conversations
  resources :messages
  resources :projects, only: [:index]
  resources :groups
  resources :requests
  resources :notifications, only: [:index]
  
  # resources :cards, only: [:create]

  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  get 'home' => 'ui#index'

  post 'incoming' => 'api#receive'

  get 'projects/:id/edit' => 'projects#edit', as: 'edit_project'
  get 'projects/:id/list_of_users' => 'projects#list_of_users', as: 'all_participants'
  #put 'projects/:id/conversations/:id' => 'projects#update', as: 'update_project'
  get 'projects/new' => 'projects#new', as: 'new_project'
  post 'projects' => 'projects#create'

  get 'welcome/home' => 'welcome#home', as: 'welcome'
  get 'groups/home' => 'groups#index'
  get 'groups/new' => 'groups#new'
  get 'groups/:id/list_of_users' => 'groups#list_of_users', as: 'all_members'
  get 'groups/:id/associated_projects' => 'groups#associated_projects', as: 'associated_projects'
  put 'projects/:id/join' => 'projects#join', as: 'join'
  put 'projects/:id/leave' => 'projects#leave', as: 'leave'
  get 'projects/:id/conversations/new' => 'conversations#new', as: 'new_convo'
  post 'projects/:id/conversations/' => 'conversations#create', as: 'create_new_convo'
  get  'projects/:id/conversations/:id' => 'conversations#show', as: 'view_convo'
  get  'projects/:id/conversations/:id/pick_users' => 'conversations#pick_users', as: 'pick_convo_users'
  put  'projects/:id/conversations/:id/add_users/' => 'conversations#add_users', as: 'add_convo_users'

  get  'projects/:id/pick_users' => 'projects#pick_users', as: 'pick_project_users'
  put  'projects/:id/add_users/' => 'projects#add_users', as: 'add_project_users'

  get 'projects/:id/dashboard' => 'projects#dashboard'
  get 'dashboard/messages' => 'dashboard#messages'
  get 'dashboard/equity' => 'dashboard#equity'
  get 'dashboard/cloud' => 'dashboard#cloud'

  post 'messages/create' => 'messages#create', as: 'post_new_message'
  #get 'projects/:project_id/show/:conversation_id' => 'projects#show', as: 'project'
  get 'projects/:project_id/show' => 'projects#show', as: 'project'
  patch 'projects/:id' => 'projects#update', as: 'update_project'

  # get 'search' => 'welcome#search', as: 'search'

  get 'users/:id/manage' => 'users#manage', as: 'manage_user'
  get 'users/:id/delete_account' => 'users#delete_account', as: 'delete_account'
  patch 'users/:id/delete_user' => 'users#delete_user', as: 'delete_user'


  get 'projects/:id/manage' => 'projects#manage_participants', as: 'manage_project'
  get 'projects/:id/remove_participants' => 'projects#remove_participants', as: 'remove_project_participants'
  put 'projects/:id/remove' => 'projects#remove_participant', as: 'remove_project_participant'
  get 'projects/:id/transfer_leadership' => 'projects#transfer_leadership', as: 'transfer_project_leadership'
  post 'projects/:id/new_leader' => 'projects#new_leader', as: 'new_leader'

  put 'requests/:id/approve' => 'requests#approve', as: 'approve_request'
  put 'requests/:id/decline' => 'requests#decline', as: 'decline_request'
  put 'requests/:id/cancel_request' => 'requests#cancel_request', as: 'cancel_request'
  
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

  # get 'notifications' => 'welcome#notifications', as: 'notifications'
  get 'projects/:id/change_plan' => 'projects#change_plan', as: 'change_project_plan'
  

  get 'search' => 'search#index', :as => 'search'
  get 'search/contacts' => 'search#contacts', :as => 'contacts_results'
  get 'search/projects' => 'search#projects', :as => 'projects_results'
  get 'search/groups' => 'search#groups', :as => 'groups_results'


  put 'admin/:id/change_user_status' => 'admin#change_user_status', :as => 'update_user_status' 
  put 'admin/:id/change_project_status' => 'admin#change_project_status', :as => 'update_project_status' 
  put 'admin/:id/change_group_status' => 'admin#change_group_status', :as => 'update_group_status' 

  get 'welcome/contact_us' => 'welcome#contact_us', :as => 'contact_us'
  get 'welcome/about_us' => 'welcome#about_us', :as => 'about_us'
  get 'welcome/plan' => 'welcome#plan', :as => 'plan'
  post 'welcome/send_authentication_code' => 'welcome#send_authentication_code', :as => 'send_authentication_code'
  post 'welcome/authenticate_code' => 'welcome#authenticate_code', :as => 'authenticate_code'
  
  put 'notifications/mark_as_read' => 'notifications#mark_as_read', :as => 'mark_as_read'
  put 'notifications/mark_all_as_read' => 'notifications#mark_all_as_read', :as => 'mark_all_as_read'
  

  # get 'payments/:id/pay' => 'payments#pay', :as => 'pay'
  # post 'payments/:id/pay_amount' => 'payments#pay_amount', :as => 'pay_amount'
  # post 'paypal_hook' => 'payments#paypal_hook', :as => 'paypal_hook'
  # post 'paypal_notification' => 'payments#paypal_notification', :as => 'paypal_notifications'

  resources :passwords do
    collection do
      put 'change_password', as: :change
    end
  end


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
