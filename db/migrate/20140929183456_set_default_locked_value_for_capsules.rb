class SetDefaultLockedValueForCapsules < ActiveRecord::Migration
  def up
		capsules = Capsule.all
		capsules.each do |cap|
			cap.locked = false
			if cap.save
				puts "#{cap.name} successfully set to open"
			else
				puts "#{cap.name} unable to set capsule to open."
				puts "ID -> #{cap.named_url}"
			end
		end
  end

  def down
		capsules = Capsule.all
		capsules.each do |cap|
			cap.locked = nil
			if cap.save
				puts "#{cap.name} successfully set to nil"
			else
				puts "Unable to change capsule setting: #{cap.name}"
			end
		end
  end
end
