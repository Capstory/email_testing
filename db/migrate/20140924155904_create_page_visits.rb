class CreatePageVisits < ActiveRecord::Migration
  def change
    create_table :page_visits do |t|
      t.string :remote_ip
      t.string :original_url
      t.integer :trackable_id
      t.string :trackable_type

      t.timestamps
    end
  end
end
