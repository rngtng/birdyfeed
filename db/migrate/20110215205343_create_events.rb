class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :event_account

      t.string :name
      t.datetime :start_at
      t.datetime :end_at

      t.boolean :all_day, :default => false
      t.string :color

      t.text :raw_card

      t.timestamps
    end
  end
end
