class AddNamedUrlToCapsules < ActiveRecord::Migration
  class Capsule <ActiveRecord::Base
    attr_accessible :named_url
  end
  
  def up
    add_column :capsules, :named_url, :string
    Capsule.reset_column_information
    Capsule.all.each do |cap|
      named_url = cap.email.nil? ? nil : cap.email.split("@").first
      cap.update_attributes(named_url: named_url)
    end
  end
  
  def down
    remove_column :capsules, :named_url
  end
end
