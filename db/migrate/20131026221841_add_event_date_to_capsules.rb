class AddEventDateToCapsules < ActiveRecord::Migration
  def change
    add_column :capsules, :event_date, :date
  end
end
