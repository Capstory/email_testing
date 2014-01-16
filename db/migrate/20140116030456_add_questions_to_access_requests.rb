class AddQuestionsToAccessRequests < ActiveRecord::Migration
  def change
    add_column :access_requests, :questions, :text
  end
end
