class AddTemplateUrlToCapsules < ActiveRecord::Migration
  def change
    add_column :capsules, :template_url, :string
  end
end
