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

    def options(*args, &block)
      map_method(:options, *args, &block)
    end

    def propfind(*args, &block)
      map_method(:propfind, *args, &block)
    end
  end
end

Birdyfeed::Application.routes.draw do

  # ## BEGIN MacOSX 10.6 hacks
  # match '/' => redirect('/carddav/'), :via => [:propfind]
  # match '/principals/carddav' => redirect('/carddav/'), :via => [:propfind]
  # ## END MacOSX 10.6 hacks

  namespace "card_dav", :path => '' do
    # card_dav_resources :principals

    card_dav_resources :book do
      card_dav_resources :contacts
    end
  end

  # root :to => DAV4Rack::Carddav.app
  # match '/books', :to => DAV4Rack::Carddav.app

  # # TODO: Refactor these…
  # constraints(ForceHTTPAuthConstraint) do
  #   match '/carddav/', :to => DAV4Rack::Handler.new(
  #     :root => '/carddav',
  #     :root_uri_path => '/carddav',
  #     :resource_class => Carddav::PrincipalResource,
  #     :controller_class => Carddav::BaseController
  #   )

  #   match '/book/:book_id/:card_id', :to => DAV4Rack::Handler.new(
  #     :root => '/book',
  #     :root_uri_path => '/book',
  #     :resource_class => Carddav::ContactResource,
  #     :controller_class => Carddav::BaseController
  #   )

  #   match '/book/:book_id', :to => DAV4Rack::Handler.new(
  #     :root => '/book',
  #     :root_uri_path => '/book',
  #     :resource_class => Carddav::AddressBookResource,
  #     :controller_class => Carddav::AddressBookController
  #   )

  #   match '/book/', :to => DAV4Rack::Handler.new(
  #     :root => '/book',
  #     :root_uri_path => '/book',
  #     :resource_class => Carddav::AddressBookCollectionResource,
  #     :controller_class => Carddav::BaseController
  #   )
  # end


  # match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}

  # resources :accounts do
  #   member do
  #       get 'import'
  #   end
  # end

  # match "event(/:id)" => "calendar#index", :as => :event

end
