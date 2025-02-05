Rails.application.routes.draw do
  resources :customers
  resources :orders, only: [:create]
end
