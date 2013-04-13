class ContactFileImportAccount < ContactAccount

  def import
    Vcard::Vcard.decode(file_data.to_s).each do |item|
      debugger

      filename   = # File.basename(item.url.to_s)
      updated_at = Time.now # item.properties.lastmodificationdate
      created_at = Time.now # item.properties.creationdate rescue updated_at
      import_item("#{filename}-#{id}", item.content.force_encoding('ASCII-8BIT'), created_at, updated_at)
    end
  end

  def file_data
    @file_data ||= File.read(self.url)
  end
end
