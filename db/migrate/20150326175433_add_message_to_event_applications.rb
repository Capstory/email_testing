class AddMessageToEventApplications < ActiveRecord::Migration
  def change
    add_column :event_applications, :message, :text
  end
end
