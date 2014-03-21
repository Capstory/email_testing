class CreateEngagedContacts < ActiveRecord::Migration
  def change
    create_table :engaged_contacts do |t|
      t.string :name
      t.string :email
      t.string :engaged_email
      t.string :engaged_name

      t.timestamps
    end
  end
end
