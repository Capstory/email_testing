class AddPaddingLeftToLogos < ActiveRecord::Migration
  def change
    add_column :logos, :padding_left, :integer
  end
end
