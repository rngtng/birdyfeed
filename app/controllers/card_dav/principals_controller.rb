module CardDav
  class PrincipalsController < CardDavController
    enable_webdav_for :index,
      :collection => true

    enable_webdav_for :show,
      :collection => true

    def index
      redirect_to "/principals/#{@current_username}/"
    end

    def show
      params["propfind"] ||= {"xmlns"=>"DAV:", "allprop"=>nil}

      respond_to do |format|
        format.webdav do |dav|
          # @foos.each |foo|
          dav.subresource card_dav_principal_book_url(@current_username, "default")

          # end
          dav.format :xml, :size => 1, :updated_at => Time.now, :current_user_principal => @current_username
        end
      end
    end

  end
end
