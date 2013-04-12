class CardDavController < ActionController::Base
  REALM = "SuperSecret"
  USERS = { "tobi" => Digest::MD5.hexdigest(["tobi", REALM, "asdasd"].join(":")) }

  before_filter :authenticate

  private
  def authenticate
    authenticate_or_request_with_http_digest(REALM) do |username|
      @current_username = username
      USERS[username]
    end
  end


end
