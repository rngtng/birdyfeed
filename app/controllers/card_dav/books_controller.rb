module CardDav
  class BooksController < CardDavController
    enable_webdav_for :index,
      :accept => :xml,
      :format => :xml,
      :collection => true

    enable_webdav_for :show,
      :accept => :xml,
      :format => :xml,
      :collection => true

    def index
      @books = current_user.books
    end

    def show
      @books = current_user.books.find(params[:id])
    end

    # def update
    # end

    # def delete
    # end

  end
end
