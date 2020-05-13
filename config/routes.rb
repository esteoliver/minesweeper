Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root "app#landing"

  get 'play', to: 'app#play'
  get 'profiles/me', to: 'profiles#show'

  devise_for :players
  namespace :players do
    root to: redirect('/profiles/me')
  end

  defaults format: :json do
    namespace :api do
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
  
end
