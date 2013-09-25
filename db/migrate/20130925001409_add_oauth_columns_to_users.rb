class AddOauthColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :oauth_expires_at, :datetime
    add_column :users, :oauth_token, :string
  end
end
