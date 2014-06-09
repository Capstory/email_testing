class TestProgramVisit < ActiveRecord::Base
  attr_accessible :ip_address, :phaseline_one, :phaseline_three, :phaseline_two, :test_version

  def resolve_phaseline(phaseline)
  	case phaseline
  	when "1"
  		self.phaseline_one = true
  	when "2"
  		self.phaseline_two = true
  	when "3"
  		self.phaseline_three = true
  	end
  	self.save
  end

end
