
class EventAccount < Account

  has_many :events

  def import
    self.events.destroy_all

    self.client.start do |connection|
       connection.find('.') do |item|
         self.events.create(:raw_card => item.content)
       end
    end
  end

end
