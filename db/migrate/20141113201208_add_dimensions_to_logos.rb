class AddDimensionsToLogos < ActiveRecord::Migration
  def change
    add_column :logos, :height, :integer
    add_column :logos, :width, :integer
  end
end
