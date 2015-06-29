class AddStatusToAlbumOrders < ActiveRecord::Migration
  def change
    add_column :album_orders, :status, :string
  end
end
