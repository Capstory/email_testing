class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.string :name
      t.string :email
      t.text :customer_hash, limit: nil

      t.timestamps
    end
  end
end
