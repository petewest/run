Run::Application.routes.draw do
  match "/about", to: "static_pages#about", via: 'get'
  match "/signup", to: 'users#new', via: 'get'
  match "/signin", to: 'sessions#new', via: 'get'
  match "/signout", to: 'sessions#destroy', via: 'delete'
  resources :categories
  resources :posts
  resources :activity_types, only: [:index, :new, :create, :destroy, :update, :edit]
  resources :users do
    resources :sessions, only: [:index, :destroy]
  end
  resources :sessions, only: [:new, :create, :destroy]
  root 'posts#index'
  
  match '/feed', to: 'posts#index', via: 'get', defaults: {format: 'rss'}

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
