# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contact_account, :class => 'ContactAccount' do
    url      "http://exmaple.test:8081/caldav.php/username/addressbook/"
    username 'tobi'
    password 'snd'
  end
end
