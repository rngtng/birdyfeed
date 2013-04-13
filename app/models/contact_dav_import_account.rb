class ContactDavImportAccount < ContactAccount

  def import(max_items = 0)
    items = 0
    dav_client.start do |connection|
      connection.find('.') do |item|
        filename   = File.basename(item.url.to_s)
        updated_at = item.properties.lastmodificationdate
        created_at = item.properties.creationdate rescue updated_at
        import_item("#{filename}-#{id}", item.content.force_encoding('ASCII-8BIT'), created_at, updated_at)
        items += 1
        return if items > max_items
      end
    end
  end
end
