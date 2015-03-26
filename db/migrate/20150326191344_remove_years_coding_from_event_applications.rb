class RemoveYearsCodingFromEventApplications < ActiveRecord::Migration
  def up
    remove_column :event_applications, :years_coding
  end

  def down
    add_column :event_applications, :years_coding, :string
  end
end
