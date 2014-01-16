class AddIndustryRoleToAccessRequests < ActiveRecord::Migration
  def change
    add_column :access_requests, :industry_role, :string
  end
end
