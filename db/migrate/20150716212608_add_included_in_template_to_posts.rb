class AddIncludedInTemplateToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :included_in_template, :boolean, default: false
  end
end
