# Birdy Feed

Get daily your friends birthdays via a Feed

## check
http://dev.elevationblog.com/2009/7/23/event-calendar-rails-plugin

sabgredav impl: https://github.com/jeromeschneider/Baikal
rails carddav: https://github.com/inferiorhumanorgans/meishi

## done
  * create an entry for each remote item

## TODO
  * move raw_card and blob into own table...
  * extend to a global vcard & ical backupstore
  * get basics:
    - vcard: name, tel, email, birthday, address, notes, picture?
    - ical: date, title, calendar

  * papercip plguin store image in DB??
  * deploy heroku -> DB just 5MB

  * pull down dav changes & put them into DB

  * add type to account -> sabredav/davical or calendar/adressbook
