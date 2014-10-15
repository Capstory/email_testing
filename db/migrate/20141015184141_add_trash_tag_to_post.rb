class AddTrashTagToPost < ActiveRecord::Migration
  def change
    add_column :posts, :tag_for_deletion, :boolean
  end
end
