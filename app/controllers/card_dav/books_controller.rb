module CardDav
  class BooksController < CardDavController

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
