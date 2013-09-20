Benesse::Application.routes.draw do
  get "api/user_list" => 'api#user_list'
  get "api/projects" => 'api#projects'

  root to: 'projects#index'

  resources :projects do
    member do
      get :authors
      put :authors, action: :author_update
#       get :check, constraints: { status: /^html|^test|^production/ }
      get :update_branch
      get :confirm
      get :confirm_html
      get :upload_compleat
      get :downloads, controller: :downloads, action: :index
      post :remind_mail
      post :comment

      resources :close_outs, only: [:test, :production] do
        collection do
          get :test
          get :production
        end
      end

      resources :confirms, only: [:authors] do
        collection do
          get :authority
        end
      end
    end

    resources :parties
    resources :branches
    resources :confirmations
    resources :upload, only: [:index, :create]
  end
  resources :departments
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :aws, only: [:index, :actions] do
    collection do
      get :index
      post :actions
    end
  end

  match 'login' => 'sessions#new', as: :login
  match 'logout' => 'sessions#destroy', as: :logout

  match 'projects/:id/check/:status' => 'projects#check', via: :get
  match 'projects/:id/check/:status' => 'projects#check_confirmation', via: :put

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
