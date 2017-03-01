Rails.application.routes.draw do
  resources :terms
  resources :articles
  resources :categories
  resources :items
  resources :bins
  devise_for :admins
  devise_for :city_officials
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :cities
  root 'categories#index'
end
