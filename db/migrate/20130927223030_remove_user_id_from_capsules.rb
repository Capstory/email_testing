class RemoveUserIdFromCapsules < ActiveRecord::Migration
  def up
    remove_column :capsules, :user_id
  end

  def down
    add_column :capsules, :user_id, :string
  end
end
