class CreateTestProgramVisits < ActiveRecord::Migration
  def change
    create_table :test_program_visits do |t|
      t.string :ip_address
      t.string :test_version
      t.boolean :phaseline_one
      t.boolean :phaseline_two
      t.boolean :phaseline_three

      t.timestamps
    end
  end
end
