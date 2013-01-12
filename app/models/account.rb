require 'net/dav'

class Account < ActiveRecord::Base

  def client
    @client ||= Net::DAV.new(self.url).tap do |client|
      client.credentials(self.username, self.password)
      client.verify_server = false
    end
  end
end
