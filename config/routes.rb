Benesse::Application.routes.draw do
  root to: 'projects#index'

  # リファクタリング後
#   namespace :api do
#     resources :users, only: :index
#     resources :projects, only: :index do
#       get :close
#       resources :files, only: :index
#     end
#   end
#
#   resources :projects do
#     get :send_mail, on: :member
#
#     resources :change_users
#     resources :checkups do
#       put :confirmation
#     end
#     resources :files
#     resouces :comments
#     resources :confirms, only: [] do
#       collection do
#         put :authority
#         put :aws
#         put :project
#         put :update_branch
#         put :miss
#         put :aws_reset
#       end
#     end
#     resources :parties, except: [:index, :show]
#   end
#
#   resources :departments, except: [:show]
#   resources :users, except: [:show]
#   resources :sessions, only: [:new, :create, :destroy]
#   resources :aws, only: [:index, :create, :update, :destroy]
#
#   match 'login' => 'sessions#new', as: :login
#   match 'logout' => 'sessions#destroy', as: :logout


  # リファクタリング前
  get "api/user_list" => 'api#user_list'
  get "api/projects" => 'api#projects'
  get "downloads" => 'downloads#optional'
  post "downloads/get_url" => 'downloads#get_url'

  resources :projects do
    member do
      get :authors
      put :authors, action: :author_update
      get :check, constraints: { status: /^aws|^test|^production/ }
      put :check, action: :check_confirmation
      get :downloads, controller: :downloads, action: :index
      post :comment

      resources :close_outs, only: [] do
        collection do
          get :test
          get :production
        end
      end

      resources :confirms, only: [] do
        collection do
          get :authority
          get :aws
          get :project
          get :update_branch
          get :miss
          get :aws_reset
        end
      end

      resources :mail, only: [] do
        collection do
          post :remind
          post :confirmation_request
        end
      end

      resources :upload, only: [:index, :create]
    end

    resources :parties, except: [:index, :show]
  end

  resources :departments, except: [:show]
  resources :users, except: [:show]
  resources :sessions, only: [:new, :create, :destroy]
  resources :aws, only: [:index] do
    collection do
      get :index
      post :actions
    end
  end

  match 'login' => 'sessions#new', as: :login
  match 'logout' => 'sessions#destroy', as: :logout
end
