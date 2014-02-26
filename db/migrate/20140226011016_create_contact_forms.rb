class CreateContactForms < ActiveRecord::Migration
  def change
    create_table :contact_forms do |t|
      t.string :name
      t.string :email
      t.text :message, limit: nil

      t.timestamps
    end
  end
end
