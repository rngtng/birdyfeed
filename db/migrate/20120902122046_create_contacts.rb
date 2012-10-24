class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|

      t.string :first_name
      t.string :last_name
      t.string :nick_name
      t.string :company


      t.string :tel_1
      t.string :tel_2

      t.string :email
      t.string :url

      t.string :birthday


      t. :street
      t. :plz
      t. :city
      t. :country



      t.string :skype
      t.text :social

      t.string :tags

      # :skype
      #
      # t.string :twitter
      #t.string :icq
      #t.string :jabber
      #t.string :irc
      #t.string :soundcloud

      t.string :picture

      t.string :notes

      t.timestamps
    end
  end
end
