class AddLockedToCapsules < ActiveRecord::Migration
  def change
    add_column :capsules, :locked, :boolean
  end
end
