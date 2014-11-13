class CreateLogos < ActiveRecord::Migration
  def change
    create_table :logos do |t|
      t.string :image
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.integer :logoable_id
      t.string :logoable_type

      t.timestamps
    end
  end
end
