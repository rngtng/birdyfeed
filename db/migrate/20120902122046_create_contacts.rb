class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :contact_account
      t.string :uid

      t.string :first_name
      t.string :last_name
      t.string :nick_name
      t.string :company

      t.string :birthday

      t.string :tel_1
      t.string :tel_2

      t.string :email
      t.string :url

      t.string :street
      t.string :plz
      t.string :city
      t.string :country

      t.text :social #:skype, :twitter, :icq, :jabber, :msn, :facebook, :soundcloud
      t.text :additional_data

      t.string :tags

      t.text :notes

      t.timestamps
    end

    add_index :contacts, [:uid], :unique => true

  end
end
