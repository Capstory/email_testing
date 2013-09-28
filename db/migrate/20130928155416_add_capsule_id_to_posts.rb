class AddCapsuleIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :capsule_id, :integer
  end
end
