class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.references :contact
      t.binary :data, :limit => 500.kilobytes
      t.string :format

      t.timestamps
    end
  end
end
