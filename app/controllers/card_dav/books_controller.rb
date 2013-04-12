module CardDav
  class BooksController < CardDavController
    enable_webdav_for :index,
      :collection => true

    enable_webdav_for :show,
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
