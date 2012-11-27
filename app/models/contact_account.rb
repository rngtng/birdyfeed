
class ContactAccount < Account

  has_many :contacts

  def import(max_items)
    self.contacts.destroy_all

    items = 0
    self.client.start do |connection|
      connection.find('.') do |item|
        begin
          next if item.content.include?("Simmersbach;Melanie")

          self.contacts.create(:raw_card => item.content)
          items += 1
          return if items > max_items
        rescue => e
         puts "Card Failed: #{e.message}"
        end
      end
    end
  end

end
