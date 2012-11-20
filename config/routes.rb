require 'sidekiq/web'
TopicHog::Application.routes.draw do
  
  mount Ckeditor::Engine => '/ckeditor'

  authenticated :user do
    root :to => 'static_pages#home'
  end
  
  root to: 'static_pages#home'
  match '/help', to: 'static_pages#help'
  match '/learn_more', to: 'static_pages#learn_more'
  match '/how-to-create-a-profession-portfolio', to: 'static_pages#professional_landing_page'
  
  resources :posts, only: [:index, :destroy]
  get 'posts/:tag1', to: 'posts#index', as: :post

  devise_for :users #, :controllers => { :registrations => "registrations" } 
  resources :token_authentications, :only => [:create, :destroy]
  resources :topicdraftimages, :only => [:create, :update, :edit, :destroy]
  resources :projectdraftimages, :only => [:create, :update, :edit, :destroy]
  resources :users, :only => [:show, :index] do
    member do
      get :following, :followers 
    end
    member do
      get :liked
    end
    resources :posts, only: [:index] do
      member do
        get :likers
      end
    end

    resources :projects, :only => [:show]
    #resources :projects, :only => [:create, :show, :new, :edit] 
    #resources :projects, :only => [ :update] , as: :update_projects
    resources :projectdrafts, :only => [:create, :show, :new, :edit, :destroy] do
     member do
        get :publish
      end
     member do
        get :discard
      end       
    end
    resources :projectdrafts, :only => [ :update] , as: :update_projectdrafts
    resources :pposts, :only => [:create, :show, :new] 
    resources :tposts, :only => [:create, :show, :new] 
    resources :topics, :only => [:create, :show, :new, :edit]     
    resources :topics, :only => [ :update] , as: :update_topics
    resources :topicdrafts, :only => [:create, :show, :new, :edit, :destroy] do
     member do
        get :publish
      end
     member do
        get :discard
      end 
    end
    resources :topicdrafts, :only => [ :update] , as: :update_topicdrafts
  end
  #demo of direct uploading in background process as per railscast
  #resources :paintings

  
  resources :profiles, only: [:edit, :update, :show]
  resources :user_preferences, only: [:edit, :update]
  resources :avatars, only: [:edit, :update]
  resources :relationships, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]
  resources :tags_names
  
  mount Sidekiq::Web, at: '/sidekiq'
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

