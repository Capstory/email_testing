class AddPinCodeToCapsule < ActiveRecord::Migration
  def change
    add_column :capsules, :pin_code, :string
  end
end
