class CardDavController < ActionController::Base
  REALM = "SuperSecret"
  USERS = { "tobi" => Digest::MD5.hexdigest(["tobi", REALM, "asdasd"].join(":")) }

  before_filter :authenticate

  # OPTIONS   -> options
  # HEAD      -> head
  # GET       -> show
  # PUT       -> update
  # POST      -> create
  # DELETE    -> destroy
  # PROPFIND  -> propfind
  # PROPPATCH
  # MKCOL
  # COPY
  # MOVE
  # LOCK
  # UNLOCK

  # Return response to OPTIONS
  # def options
  #   response.header["Allow"] = 'OPTIONS,HEAD,GET,PUT,POST,DELETE,PROPFIND,PROPPATCH,MKCOL,COPY,MOVE,LOCK,UNLOCK'
  #   render :text => "", :status => :ok
  # end

  # def propfind
  #   properites = params["propfind"]["prop"]

  #   render :xml => Nokogiri::XML::Builder.new { |xml|
  #     xml.multistatus('xmlns' => 'DAV:') {
  #       xml.response {
  #         xml.href
  #       }
  #     }
  #   }, :status => 207
  # end

  # def head
  #   response.header['Etag'] = resource.etag
  #   response.header['Content-Type'] = resource.content_type
  #   response.header['Last-Modified'] = resource.last_modified.httpdate
  #   response.header['Content-Length'] = resource.content_length.to_s
  # end

  private
  # def add_dav_header
  #   unless(response['Dav'])
  #     dav_support = %w(1 2) + @dav_extensions
  #     response['Dav'] = dav_support.join(', ')
  #   end
  # end

  def authenticate
    authenticate_or_request_with_http_digest(REALM) do |username|
      @current_username = username
      USERS[username]
    end
  end


end
