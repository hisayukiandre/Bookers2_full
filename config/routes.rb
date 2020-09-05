Rails.application.routes.draw do
  root :to => 'top#index'
  get 'home/about' => 'top#about', as: 'home_about'
  devise_for :users
  resources :books
  resources :users, only: [:index, :edit, :update, :show]
end
