Rails.application.routes.draw do
  root 'main#index'
  resources :games do
    member do
      post :player_vote
      post :clear_votes
      post :show_votes
      post :join
    end

    resources :games_players
  end
  resources :unknown_risks
  resources :complexities
  resources :amount_of_works
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
