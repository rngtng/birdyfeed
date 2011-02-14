atom_feed do |feed|
  feed.title(@title)

  feed.updated(@updated)

   @feed_items.each do |item|
    feed.entry(item) do |entry|

      entry.title(item.title)
   #   entry.summary("item.summary", :type => "html")
      entry.content(item.summary, :type => "html")

    end
  end
end