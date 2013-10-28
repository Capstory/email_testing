class AddDateToAccessRequests < ActiveRecord::Migration
  def change
    add_column :access_requests, :event_date, :date
  end
end
