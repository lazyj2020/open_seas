ActionController::Routing::Routes.draw do |map|
  map.resources :time_tasks

  map.resources :news_posts

  map.resources :battles

  map.resources :merchants
  map.resources :messages
  
  map.resources :ship_attributes
  
  map.resources :ship_items

  map.resources :items

  map.resources :routes

  map.resources :ports

  map.resources :ships

  map.resources :characters

  map.resources :categories
  map.resources :users, :controller => 'user'
  map.resources :sent, :mailbox
  map.resources :messages, :member => {  :reply => :get, :forward => :get, :reply_all => :get }
  map.resource :session

  map.root :controller => "site", :action => "index"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
