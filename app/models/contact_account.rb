
class ContactAccount < Account

  has_many :contacts

  def import(max_items)
    # self.contacts.destroy_all

    items = 0
    self.client.start do |connection|
      connection.find('.') do |item|
        File.basename(item.url.to_s).tap do |uid|
          begin
            self.contacts.find_or_initialize_by_uid(uid).tap do |contact|
              if item.properties.lastmodificationdate > contact.updated_at
                contact.created_at ||= item.properties.creationdate
                contact.updated_at ||= item.properties.lastmodificationdate

                contact.import(item.content)
                contact.save!

                contact.raw_card = item.content
                contact.save!
              else
                puts "DB entry is newer"
              end
            end
            items += 1
            return if items > max_items
          rescue => e
            puts "Card Failed: #{e.class}"
            File.open(filename, 'w') { |f| f.print item.content }
          end
        end
      end
    end
  end

end
