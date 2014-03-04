class AddDateInStringToReminder < ActiveRecord::Migration
  def change
    add_column :reminders, :date, :string
  end
end
