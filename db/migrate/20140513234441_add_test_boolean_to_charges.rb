class AddTestBooleanToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :is_test, :boolean, default: false
  end
end
