class CardDavController < DAV4Rack::Controller

  # OPTIONS
  # HEAD
  # GET      -> show
  # PUT      -> update
  # POST     -> create
  # DELETE   -> destroy
  # PROPFIND
  # PROPPATCH
  # MKCOL
  # COPY
  # MOVE
  # LOCK
  # UNLOCK

  # Return response to OPTIONS
  def options
    @response["Allow"] = 'OPTIONS,HEAD,GET,PUT,POST,DELETE,PROPFIND,PROPPATCH,MKCOL,COPY,MOVE,LOCK,UNLOCK'
    OK
  end

  def head
    response['Etag'] = resource.etag
    response['Content-Type'] = resource.content_type
    response['Last-Modified'] = resource.last_modified.httpdate

    response['Content-Length'] = resource.content_length.to_s
  end


end
