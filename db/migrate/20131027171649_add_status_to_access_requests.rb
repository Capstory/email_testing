class AddStatusToAccessRequests < ActiveRecord::Migration
  def change
    add_column :access_requests, :request_status, :string
  end
end
