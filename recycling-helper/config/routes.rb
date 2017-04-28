Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  get 'cities/find/location', to: 'cities#by_location', as: 'city_by_location'
  get 'cities/search', to: 'cities#search', as: 'search_cities'
  get 'cities/:id/search', to: 'cities#search_items', as: 'search_items'

  get 'articles/search', to: 'articles#search', as: 'search_articles'

  resources :articles
  resources :cities, except: [:new, :create]
  resources :items, only: [:create, :update, :destroy]
  resources :bins, only: [:create, :update, :destroy]

  devise_for :admins
  devise_for :city_officials

  # The root url points to a stub page. The only role of this page is to see if a user has location
  # enabled and, if so, direct them to their cities page. Otherwise, they are sent to the real home
  # page, which is cities#index.
  root to: 'root#redirect'
end
