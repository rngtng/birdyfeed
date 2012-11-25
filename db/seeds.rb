# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

## Davical
# Travel
ContactAccount.create(
  :url => "http://davical.warteschlange.de:8081/caldav.php/travel/addressbook/",
  :username => 'tobi',
  :password => 'snd'
)

# Tobi
ContactAccount.create(
  :url => "http://davical.warteschlange.de:8081/caldav.php/tobi/addressbook/",
  :username => 'tobi',
  :password => 'snd'
)

## Sabredav
# Tobi
ContactAccount.create(
  :url => "https://dav.warteschlange.de:8443",
  :username => 'tobi',
  :password => 'snd'
)
