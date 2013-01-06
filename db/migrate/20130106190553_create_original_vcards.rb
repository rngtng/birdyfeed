class CreateOriginalVcards < ActiveRecord::Migration
  def change
    create_table :original_vcards do |t|
      t.references :contact
      t.text :data, :limit => 500.kilobytes

      t.timestamps
    end
  end
end
