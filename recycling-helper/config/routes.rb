Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  resources :terms
  resources :articles

  get 'articles/new'

  get 'articles/index'

  get 'articles/show'

  get 'articles/create'

  resources :categories
  resources :items
  resources :bins
  resources :cities, except: [:new, :create]

  get 'bins/new'

  get 'bins/index'

  get 'bins/show'

  get 'bins/create'

  devise_for :admins
  devise_for :city_officials
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :cities

  get 'cities/find/location', to: 'cities#by_location', as: 'city_by_location'

  # The root url points to a stub page. The only role of this page is to see if a user has location
  # enabled and, if so, direct them to their cities page. Otherwise, they are sent to the real home
  # page, which is cities#index.
  root to: 'root#redirect'
end
