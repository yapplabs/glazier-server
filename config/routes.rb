GlazierServer::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  get '/api/oauth/callback', to: 'oauth/flow#callback'
  get '/api/oauth/github/callback', to: 'oauth/github#callback'
  post '/api/oauth/github/exchange', to: 'oauth/github#exchange'
  get '/api/' => 'apps#index'
  get "/api/dashboards", to: 'dashboards#index'
  get "/api/dashboards/*id", to: 'dashboards#show', format: false

  namespace '/api', module: nil, defaults: {format: 'json'} do
    resource :session, only: [:create, :destroy]
    resource :user, only: [:show]
    resources :panes, only: [:index]
    resources :pane_types, only: [:index]

    put    "/pane_entries/:pane_id", to: 'pane_entries#update'
    delete "/pane_entries/:pane_id", to: 'pane_entries#destroy'

    put    "/pane_user_entries/:pane_id", to: 'pane_user_entries#update'
    delete "/pane_user_entries/:pane_id", to: 'pane_user_entries#destroy'

    put    "/pane_type_user_entries/:pane_type_name", to: 'pane_type_user_entries#update'
    delete "/pane_type_user_entries/:pane_type_name", to: 'pane_type_user_entries#destroy'
  end

  root :to => 'apps#index'

  get "/:github_user/*github_repo", format: false,
      github_user: /[a-z0-9-]+/i,
      to: redirect("/#/%{github_user}/%{github_repo}")
end
