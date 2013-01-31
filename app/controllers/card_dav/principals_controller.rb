module CardDav
  class PrincipalsController < CardDavController
    enable_webdav_for :index,
      :accept => :xml,
      :format => :xml,
      :current_user_principal => "ass"

    enable_webdav_for :show,
      :accept => :xml,
      :format => :xml,
      :collection => false,
      :current_user_principal => "ass"

    def index
      respond_to do |format|
        format.webdav do |dav|
          # @foos.each |foo|
          dav.subresource "/principals/1"
          dav.subresource "/principals/2"
          # end
          dav.format :xml, :size => 1, :updated_at => Time.now, :current_user_principal => "asasds"
        end
      end
    end

  end
end
