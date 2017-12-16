AdPro::Application.routes.draw do
  root 'campaigns#index'

  resources :campaigns
  resources :time_slots
  resources :banners
end
