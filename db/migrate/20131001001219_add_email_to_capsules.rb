class AddEmailToCapsules < ActiveRecord::Migration
  def change
    add_column :capsules, :email, :string
  end
end
