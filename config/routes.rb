Rails.application.routes.draw do
  # devise_for :users
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions', omniauth_callbacks: 'users/omniauth_callbacks' }

  scope '(:locale)', locale: /en|fr|es/ do
    root to: 'pages#home'
    get '/conversion', to: 'pages#conversion', as: 'conversion'
    get '/tools', to: 'pages#tools', as: 'tools'
    get '/admin', to: 'admin#index', as: 'admin'
    get '/admin/users', to: 'admin#users', as: 'admin_users'
    get '/admin/recipes', to: 'admin#recipes', as: 'admin_recipes'
    get '/admin/comments', to: 'admin#comments', as: 'admin_comments'
    # get '/admin/replies', to: 'admin#replies'
    match 'users/:id' => 'users#destroy', :via => :delete, :as => :admin_destroy_user

    get '/admin/spam', to: 'admin#spam'
    post 'comments/:id/spam', to: 'comments#spam', as: :comment_spam
    post 'replies/:id/spam', to: 'replies#spam', as: :reply_spam

    resources :pages, except: [:index]
    resources :products, except: [:index, :show]
    resources :settings, only: [:index], as: :settings

    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    resources :recipes, except: [:show] do
      resource :bookmarks, only: [:update]
      resource :likes, only: [:update]
      resources :comments, except: [:index, :show] do
        resources :replies, except: [:index, :show]
      end
    end
    resources :recipes, only: [:show], path: '/r' do
      resource :bookmarks, only: [:update]
      resource :likes, only: [:update]
      resources :comments, except: [:index, :show] do
        resources :replies, except: [:index, :show]
      end
    end
    get '/recipes/:id', to: redirect('/r/%{id}')

    # get '/recettes', to: 'recipes#index', as: 'recettes'
    resources :bookmarks, only: [:index]
    resources :index, only: [:index]
    get '/index/tagged', to: "index#tagged", as: :tagged
    resources :followers, only: [:index]
    resources :following, only: [:index]

    get '/:id/followers', to: 'users#followers', as: :user_followers
    get '/:id/following', to: 'users#following', as: :user_following

    resources :users, only: [:show], path: '/u' do
      member do
        post :follow
        post :unfollow
      end
    end
    get '/users/:id', to: redirect('/u/%{id}')

  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :recipes, only: [ :index, :show, :update ]
      resources :mailchimp, only: [ :show, :update ]
      resources :notification, only: [ :show, :update ]
    end
  end

  get '/sitemap.xml', to: redirect('https://sitemap.cuisinierrebelle.com/sitemap.xml.gz', status: 301)

  # Sidekiq Web UI, only for admins.
  # require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
