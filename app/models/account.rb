require 'net/dav'

class Account < ActiveRecord::Base

  has_many :events

  def import
    self.events.destroy_all

    self.client.start do |connection|
       connection.find('.') do |item|
         self.events.create(:raw_card => item.content)
       end
    end
  end

  def client
    @client ||= Net::DAV.new(self.url).tap do |client|
      client.credentials(self.username, self.password)
    end
  end
end
