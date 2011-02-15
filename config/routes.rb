Birdyfeed::Application.routes.draw do

  root :to => 'accounts#index'

  resources :accounts do
    resource :feed
  end

  match "feed_item" => "feeds#show"

end
