require 'net/dav'

class Account < ActiveRecord::Base

  has_many :feed_items

  def import
    self.feed_items.destroy_all

    self.client.start do |connection|
       connection.find('.') do |item|
         self.feed_items.create(:raw_card => item.content)
       end
    end
  end

  def client
    @client ||= Net::DAV.new( self.url )
    @client.credentials(self.username, self.password)
    @client
  end
end
