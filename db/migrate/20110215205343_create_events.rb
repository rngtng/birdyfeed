class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.references :account

      t.string :name
      t.datetime :start_at
      t.datetime :end_at

      t.boolean :all_day, :default => false
      t.string :color

      t.text :raw_card
    end
    
    drop_table :feed_items
  end

  def self.down
    drop_table :events
  end
end
