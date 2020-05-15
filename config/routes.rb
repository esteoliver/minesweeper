Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root "app#landing"

  get 'play', to: 'app#play'
  get 'game', to: 'app#game'
  get 'login', to: 'app#login'
  get 'signup', to: 'app#signup'
  get 'profiles/me', to: 'profiles#show'

  namespace :players do
    root to: redirect('/profiles/me')
  end

  devise_for :player, path: 'api/v1/auth', controllers: {
    sessions: 'api/sessions',
    registrations: 'api/registrations'
  }

  namespace :api, defaults: { format: :json } do
    namespace :v1 do    
      resources :games, only: [:create, :show, :index] do
        member do
          put 'reveal', to: 'player_actions#reveal'
          put 'flag', to: 'player_actions#flag'
          put 'unflag', to: 'player_actions#unflag'
        end
      end
    end
  end
  
end
