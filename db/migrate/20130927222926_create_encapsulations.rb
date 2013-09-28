class CreateEncapsulations < ActiveRecord::Migration
  def change
    create_table :encapsulations do |t|
      t.integer :user_id
      t.integer :capsule_id
      t.boolean :owner
      t.boolean :guest

      t.timestamps
    end
  end
end
