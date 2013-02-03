module CardDav
  class PrincipalsController < CardDavController
    enable_webdav_for :index,
      :accept => :xml,
      :format => :xml,
      :collection => true

    enable_webdav_for :show,
      :accept => :xml,
      :format => :xml,
      :collection => true

    def index
      redirect_to "/principals/#{@current_username}/"
    end

    def show
      respond_to do |format|
        format.webdav do |dav|
          # @foos.each |foo|
          dav.subresource "/principals/#{@current_username}/books/1"

          # end
          dav.format :xml, :size => 1, :updated_at => Time.now, :current_user_principal => @current_username
        end
      end
    end

  end
end
