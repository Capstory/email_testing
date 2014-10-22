class AddRequiresVerificationToCapsules < ActiveRecord::Migration
  def change
    add_column :capsules, :requires_verification, :boolean, default: false
  end
end
