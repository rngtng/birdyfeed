module CardDav
  class ContactsController < CardDavController

    # before_filter :load_book
    # before_filter :load_contact, :only => [:show, :update, :delete]

    def index
      @contacts = @book.contacts
    end

    def show
      @contact.vcard
    end

    def create
      @contact = @book.contacts.new
      @contact.import(content)
      @contact.vcard = content
      @contact.save!
    end

    def update
      @contact.import(content)
      @contact.vcard = content
      @contact.save!
    end

    def delete
      @contact.destroy!
    end

    private
    def load_book
      @book = current_user.books.find(params[:id])
    end

    def load_contact
      @contact = @book.contacts.find(params[:id])
    end

  end
end
