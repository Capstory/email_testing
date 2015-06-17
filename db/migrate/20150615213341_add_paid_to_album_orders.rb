class AddPaidToAlbumOrders < ActiveRecord::Migration
  def change
    add_column :album_orders, :paid, :boolean
  end
end
