class CreateAccessRequests < ActiveRecord::Migration
  def change
    create_table :access_requests do |t|
      t.string :name
      t.string :email
      t.string :event_address

      t.timestamps
    end
  end
end
