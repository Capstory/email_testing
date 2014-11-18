class AddPaddingTopToLogos < ActiveRecord::Migration
  def change
    add_column :logos, :padding_top, :integer
  end
end
