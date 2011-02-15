Birdyfeed::Application.routes.draw do

  root :to => 'acalendar#index'

  match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}

  resources :accounts do
    member do
        get 'import'
    end
  end

  match "event(/:id)" => "calendar#index", :as => :event

end
