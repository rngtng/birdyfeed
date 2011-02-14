class CreateFeedItems < ActiveRecord::Migration
  def self.up
    create_table :feed_items do |t|
      t.references :account
      t.string     :name
      t.datetime   :date
      t.text       :raw_card
    end
  end

  def self.down
    drop_table :feed_items
  end
end
