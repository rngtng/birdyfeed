class Contact < ActiveRecord::Base
  # attr_accessible :title, :body

  store :social, :skype, :twitter, :icq, :jabber, :msn, :facebook, :soundcloud
  #picture blob
end
