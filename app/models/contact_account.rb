class ContactAccount < Account
  has_many :contacts

  protected
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
