Rails.application.routes.draw do
  resources :sections, only: [:index, :show, :create, :update, :destroy]

  root 'home#index'

end
