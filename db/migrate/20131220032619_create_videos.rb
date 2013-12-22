class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :zencoder_url
      t.integer :post_id

      t.timestamps
    end
  end
end
