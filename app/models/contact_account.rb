
class ContactAccount < Account

  has_many :contacts

  def import(max_items)
    self.contacts.destroy_all

    items = 0
    self.client.start do |connection|
      connection.find('.') do |item|
        updated_at = item.properties.lastmodificationdate
        created_at = item.properties.creationdate rescue updated_at
        import_item(File.basename(item.url.to_s), item.content, created_at, updated_at)
        items += 1
        return if items > max_items
      end
    end
  end

  def import_item(uid, content, created_at = nil, updated_at = nil)
    self.contacts.find_or_initialize_by_uid(uid).tap do |contact|
      if updated_at.to_i > contact.updated_at.to_i
        contact.created_at ||= Time.at(created_at.to_i)
        contact.updated_at   = Time.at(updated_at.to_i)
        contact.import(content)
        contact.vcard = content
        contact.save!
      else
        puts "DB entry is newer"
      end
    end
  end

end
