AdPro::Application.routes.draw do
  mount AdPro::API => '/'
  #namespace :v1 do
  #j  resources :campaigns, except: [:new, :edit]
  #jend
  #resources :banners

  #resources :campaigns do
    #resources :banners do
      #resources :time_slot
    #end
  #end
end
