class AddSourceColumnToContactForms < ActiveRecord::Migration
  def change
    add_column :contact_forms, :source, :string
  end
end
