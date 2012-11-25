
class ContactAccount < Account

  has_many :contacts

  def import(max_items)
    self.contacts.destroy_all

    items = 0
    self.client.start do |connection|
       connection.find('.') do |item|
         self.contacts.create(:raw_card => item.content)
         items += 1
         return if items > max_items
       end
    end
  end

end
