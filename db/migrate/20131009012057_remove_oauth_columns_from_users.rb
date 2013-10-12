class RemoveOauthColumnsFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :provider
    remove_column :users, :uid
    remove_column :users, :oauth_expires_at
    remove_column :users, :oauth_token
  end

  def down
    add_column :users, :oauth_token, :string
    add_column :users, :oauth_expires_at, :string
    add_column :users, :uid, :string
    add_column :users, :provider, :string
  end
end
