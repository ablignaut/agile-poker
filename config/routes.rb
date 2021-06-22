Rails.application.routes.draw do
  root 'main#index'
  resources :games do
    member do
      post :player_vote
      post :join
    end
  end
  resources :unknown_risks
  resources :complexities
  resources :amount_of_works
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
