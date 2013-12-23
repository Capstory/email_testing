class AddSourceToAccessRequests < ActiveRecord::Migration
  def change
    add_column :access_requests, :source, :string
  end
end
