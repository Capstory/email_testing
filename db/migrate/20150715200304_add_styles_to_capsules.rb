class AddStylesToCapsules < ActiveRecord::Migration
  def change
    add_column :capsules, :styles, :text
  end
end
