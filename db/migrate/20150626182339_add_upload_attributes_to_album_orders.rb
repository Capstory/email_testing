class AddUploadAttributesToAlbumOrders < ActiveRecord::Migration
  def change
		add_column :album_orders, :cover_photo_file_name, :string
		add_column :album_orders, :cover_photo_content_type, :string
		add_column :album_orders, :cover_photo_file_size, :integer
		add_column :album_orders, :cover_photo_updated_at, :datetime

		add_column :album_orders, :inner_file_file_name, :string
		add_column :album_orders, :inner_file_content_type, :string
		add_column :album_orders, :inner_file_file_size, :integer
		add_column :album_orders, :inner_file_updated_at, :datetime
  end
end
