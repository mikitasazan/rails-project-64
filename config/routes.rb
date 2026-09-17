Rails.application.routes.draw do
  devise_for :users
  resources :posts, only: %i[new show create] do
    resources :comments, only: %i[create]
    resources :likes, only: %i[create destroy]
  end
  root to: "posts#index"
end
