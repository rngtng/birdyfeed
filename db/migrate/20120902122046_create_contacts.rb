class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :account

      t.string :first_name
      t.string :last_name
      t.string :nick_name
      t.string :company

      t.string :tel_1
      t.string :tel_2

      t.string :email
      t.string :url

      t.string :birthday

      t.string :street
      t.string :plz
      t.string :city
      t.string :country

      t.text :social #:skype, :twitter, :icq, :jabber, :msn, :facebook, :soundcloud
      t.text :picture

      t.text :notes

      t.string :tags
      t.string :source

      t.timestamps
    end
  end
end
