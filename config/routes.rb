AdPro::Application.routes.draw do
  namespace :v1 do
    resources :campaigns, except: [:new, :edit]
  end
  #resources :banners

  #resources :campaigns do
    #resources :banners do
      #resources :time_slot
    #end
  #end
end
