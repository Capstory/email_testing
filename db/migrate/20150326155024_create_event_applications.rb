class CreateEventApplications < ActiveRecord::Migration
  def change
    create_table :event_applications do |t|
      t.string :name
      t.boolean :student, default: true
      t.string :university_year
      t.integer :years_coding
      t.string :language_preference
      t.string :work_preference
      t.string :github_account_name
      t.string :email

      t.timestamps
    end
  end
end
