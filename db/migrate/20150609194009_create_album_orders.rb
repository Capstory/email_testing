class CreateAlbumOrders < ActiveRecord::Migration
  def change
    create_table :album_orders do |t|
      t.float :total
      t.text :address
      t.text :quantities
      t.string :name
      t.string :email
      t.text :contents

      t.timestamps
    end
  end
end
