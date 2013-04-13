require 'net/dav'
class Account < ActiveRecord::Base

  protected
  def dav_client
    @dav_client ||= Net::DAV.new(self.url).tap do |client|
      client.credentials(self.username, self.password)
      client.verify_server = false
    end
  end
end
