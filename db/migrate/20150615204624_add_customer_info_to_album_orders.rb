class AddCustomerInfoToAlbumOrders < ActiveRecord::Migration
  def change
    add_column :album_orders, :customer_info, :text
  end
end
