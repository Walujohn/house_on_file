Rails.application.routes.draw do
  root to: "pages#home"
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
    
  resources :properties do
      resources :spaces, except: [:index] do
          resources :features, except: [:index, :show]
      end
      resources :appliances, except: [:index, :show] do
          resources :appliance_features, except: [:index, :show]
      end
  end
  
  resources :searches, only: :index
        
end

