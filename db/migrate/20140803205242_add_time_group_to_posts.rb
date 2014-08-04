class AddTimeGroupToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :time_group, :string
  end
end
