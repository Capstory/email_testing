class AddTimeGroupToCapsules < ActiveRecord::Migration
  def change
    add_column :capsules, :time_group, :text
  end
end
