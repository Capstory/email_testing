class AddReminderSentToReminders < ActiveRecord::Migration
  def change
    add_column :reminders, :reminder_sent, :boolean
  end
end
