class AddPartnerCodeToAccessRequests < ActiveRecord::Migration
  def change
    add_column :access_requests, :partner_code, :string
  end
end
