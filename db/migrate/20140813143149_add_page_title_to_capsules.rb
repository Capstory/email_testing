class AddPageTitleToCapsules < ActiveRecord::Migration
  def change
    add_column :capsules, :page_title, :string
  end
end
