Birdyfeed::Application.routes.draw do
  resources :accounts do
    resource :feed
  end

end
