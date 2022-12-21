Rails.application.routes.draw do
  root to: "pages#home"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
    
  resources :properties do
      resources :spaces, except: [:index, :show] do
          resources :features, except: [:index, :show]
      end
      resources :appliances, except: [:index, :show] do
          resources :appliance_features, except: [:index, :show]
      end
  end
        
end
