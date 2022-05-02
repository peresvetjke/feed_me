Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root to: "articles#index"

  resources :articles do
    get "search", on: :collection
    post "mark_read", on: :member
  end

  resources :sources do
    post :assign_to_list, on: :member
    delete :clear_assignment, on: :member
  end
  
  resources :lists
  # resources :lists, shallow: true do
  #   resources :sources
  # end

  resources :list_sources, only: [:create, :destroy]
  
  # do
  #   resources :articles, only: :index
  # end

  
  # do
  #   resources :articles, only: :index
  # end  
end
