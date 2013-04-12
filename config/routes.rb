require "railsdav/routing_extensions"

module ActionDispatch::Routing
  class Mapper

    def card_dav_resources(*resources, &block)
      CANONICAL_ACTIONS.push("propfind", "options")
      options = resources.extract_options!.dup
      options[:format] = false
      resources.push(options)
      _card_dav_resources(*resources, &block)
      # CANONICAL_ACTIONS.delete("propfind") # fails for nested attempt
      # CANONICAL_ACTIONS.delete("options")
    end

    def _card_dav_resources(*resources, &block)
      opts = resources.extract_options!.dup

      if apply_common_behavior_for(:_card_dav_resources, resources, opts, &block)
        return self
      end

      resource_scope(:resource, Resource.new(resources.pop, opts)) do
        yield if block_given?

        # concerns(opts[:concerns]) if opts[:concerns]

        collection do
          get :index
          map_method :propfind, :index_propfind
          map_method :options, :options
          post :create
        end if parent_resource.actions.include?(:create)

        member do
          get :show
          map_method :propfind, :show_propfind
          map_method :options, :options
          if parent_resource.actions.include?(:update)
            put :update
          end
          delete :destroy if parent_resource.actions.include?(:destroy)
        end
      end

      self
    end
  end
end

Birdyfeed::Application.routes.draw do

  # ## BEGIN MacOSX 10.6 hacks
  # match '/' => redirect('/carddav/'), :via => [:propfind]
  # match '/principals/carddav' => redirect('/carddav/'), :via => [:propfind]
  # ## END MacOSX 10.6 hacks

  namespace "card_dav", :path => '' do
    match "/.well-known/carddav" => redirect('/')

    root :to => 'principals#index'
    # , :via => [:propfind, :options]

    webdav_resources :principals, :format => false, :only => [:index, :show] do
      webdav_resources :books, :format => false, :only => [:index, :show] do
        webdav_resources :contacts, :format => false, :except => [:new, :edit]
      end
    end

    # card_dav_resources :principals

    # card_dav_resources :books do
    #   card_dav_resources :contacts
    # end
  end

  # match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}

  # resources :accounts do
  #   member do
  #       get 'import'
  #   end
  # end

  # match "event(/:id)" => "calendar#index", :as => :event

end
