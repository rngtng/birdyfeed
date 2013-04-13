# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

seeds = [
  [ ContactDavImportAccount,   1, "http://davical.warteschlange.de:8081/caldav.php/travel/addressbook/", 'tobi', 'snd' ],
  [ ContactDavImportAccount,   2, "http://davical.warteschlange.de:8081/caldav.php/tobi/addressbook/",   'tobi', 'snd' ],
  [ ContactDavImportAccount,   3, "https://dav.warteschlange.de:8443/addressbooks/tobi/private/",        'tobi', 'snd' ],
  [ ContactDavImportAccount,   4, "http://b.warteschlange.de/card.php/addressbooks/tobi/default/",       'tobi', 'snd' ],

  [ ContactFileImportAccount, 10, "/Users/tobi/Projects/ruby/birdyfeed/spec/fixtures/private.vcf" ],
  [ ContactFileImportAccount, 11, "/Users/tobi/Projects/ruby/birdyfeed/spec/fixtures/private" ],
  [ ContactFileImportAccount, 12, "/Users/tobi/Projects/ruby/birdyfeed/spec/fixtures/all.vcf"],
]

seeds.each do |klass, id, url, username=nil, password=nil|
  klass.find_or_initialize_by_id(id).tap do |contact|
    contact.url      = url
    contact.username = username
    contact.password = password
  end.save!
end
