Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  root 'reports#index'
  resources :reports
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
