Birdyfeed::Application.routes.draw do

  resources :accounts do
    resource :feed
  end
  
  match "feed_item" => "feeds#show"
 
end
