class AddGenreToIdentities < ActiveRecord::Migration
  def change
    add_column :identities, :genre, :string
  end
end
