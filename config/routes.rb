# frozen_string_literal: true

Wordpress::Application.routes.draw do |_map|
  root to: 'news#index'
  resources :news

  # Obviously, you can change the "news" bit :D
  match "/news/#{Option.permalink_route}", to: 'news#show'
  match '/news/feed', to: 'news#feed'
end
