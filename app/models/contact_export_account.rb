  def export
    self.client.start do |connection|
      self.contacts.each do |contact|
        connection.put_string("#{contact.new_uid}.vcf", contact.vcard)
      end
    end
  end
