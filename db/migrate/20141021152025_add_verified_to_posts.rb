class AddVerifiedToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :verified, :boolean, default: true
  end
end
