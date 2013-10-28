class AddEventDateToIdentities < ActiveRecord::Migration
  def change
    add_column :identities, :event_date, :date
  end
end
