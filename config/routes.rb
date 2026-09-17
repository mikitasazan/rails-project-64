Rails.application.routes.draw do
  devise_for :users
  resources :posts, only: %i[new show create]
  root to: "posts#index"
end
