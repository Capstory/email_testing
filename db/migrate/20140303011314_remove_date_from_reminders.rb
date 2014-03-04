class RemoveDateFromReminders < ActiveRecord::Migration
  def up
    remove_column :reminders, :date
  end

  def down
    add_column :reminder, :date, :datetime
  end
end
