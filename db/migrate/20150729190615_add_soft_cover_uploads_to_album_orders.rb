class AddSoftCoverUploadsToAlbumOrders < ActiveRecord::Migration
  def change
		add_column :album_orders, :soft_cover_file_name, :string
		add_column :album_orders, :soft_cover_content_type, :string
		add_column :album_orders, :soft_cover_file_size, :integer
		add_column :album_orders, :soft_cover_updated_at, :datetime

		add_column :album_orders, :soft_inner_file_name, :string
		add_column :album_orders, :soft_inner_content_type, :string
		add_column :album_orders, :soft_inner_file_size, :integer
		add_column :album_orders, :soft_inner_updated_at, :datetime
  end
end
