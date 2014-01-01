class AddResponseMessageToCapsules < ActiveRecord::Migration
  def change
    add_column :capsules, :response_message, :text
  end
end
