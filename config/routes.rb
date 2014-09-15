Run::Application.routes.draw do
  match "/about", to: "static_pages#about", via: 'get'
  match "/signup", to: 'users#new', via: 'get'
  match "/signin", to: 'sessions#new', via: 'get'
  match "/signout", to: 'sessions#destroy', via: 'delete'
  match "/change_password", to: 'users#change_password', via: 'get'
  resources :categories
  resources :posts do
    resources :hits, only: :index
  end
  resources :activity_types, only: [:index, :new, :create, :destroy, :update, :edit]
  resources :activities, only: [:new, :create, :destroy, :update, :edit]
  resources :users do
    resources :sessions, only: [:index, :destroy]
    resources :activities, only: [:index]
    member do
      get 'change_password'
    end
  end
    
  resources :sessions, only: [:new, :create, :destroy]
  resources :attachments, only: [:new, :create, :destroy]
  resources :attachments, only: [:index], defaults: {format: 'json'}
  resources :hits, only: :index
  
  
  root 'posts#index'
  
  match '/preview', to: 'posts#preview', via: 'post', as: 'post_preview'
  match '/feed', to: 'posts#index', via: 'get', defaults: {format: 'rss'}

  match '/activity_check', to: 'activities#check_upload', via: 'get', defaults: {format: 'json'}
  match '/map', to: 'activities#show', via: 'get', defaults: {format: 'json'}, as: 'map'
  
  match '/graph', to: 'activities#graph', via: 'get', as: 'graph'

  #Add google site verification
  get "/#{Rails.application.config.google_verification}.html",
    to: proc { |env| [200, {},
      ["google-site-verification: #{Rails.application.config.google_verification}.html"]] }
  
  
  # Test having category routes available:
  # this should probably be the last route?
  get '/:category', to: 'posts#index', as: :cat

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

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
