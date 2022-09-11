Rails.application.routes.draw do
 devise_for :users,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
 }

 devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
 }

 root to: "public/homes#top"
 get 'home/about' => 'public/homes#about', as: "about"

 namespace :admin do
  get 'admin/homes/top' => 'homes#top'

  resources :users, only: [:index, :show, :edit, :update] do
   collection do
      get "withdrawal" => "customers#withdrawal"
      patch "out" => "customers#out"
   end
  end
  resources :comments, only: [:index, :create, :destroy]
  resources :tags, only: [:index, :create, :edit, :update, :destroy]
 end

 namespace :public do
  resources :novels, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
   resource :favorites, only: [:create, :destroy]
   resources :tags, only: [:index, :create, :edit, :update, :destroy, :show]
    get 'tag_search'
   resources :novel_comments, only: [:create, :destroy]
   collection do
      get 'search'
    end
  end
  resources :users, only: [:index, :show, :edit, :update] do
   member do
    get :favorites
   end
  end
 end

end