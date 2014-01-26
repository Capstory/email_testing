class AddErrorHashToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :error_hash, :text, limit: nil
  end
end
