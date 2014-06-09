class TestProgramVisitsController < ApplicationController

	def create
		if cookies[:test_program_visit]
			redirect_to update_test_program_visit_path
		else
			test = TestProgramVisit.create do |v|
				v.ip_address = request.env["REMOTE_ADDR"]
				v.test_version = params[:test_version]
				v.phaseline_one = false
				v.phaseline_two = false
				v.phaseline_three = false
			end
			cookies[:test_program_visit] = { value: JSON.generate([request.env["REMOTE_ADDR"], test.id]), expires: 3.hours.from_now }
			redirect_to self.send(resolve_path(test.test_version))
		end
	end

	def update
		if cookies[:test_program_visit]
			cookie_value = JSON.parse(cookies[:test_program_visit])
			@test_visit = TestProgramVisit.find_by_ip_address_and_id(cookie_value.first, cookie_value.last)
			@test_visit.resolve_phaseline(params[:phaseline])
			if params[:phaseline]
				case params[:phaseline]
				when "1"
					redirect_to pricing_path
				when "2"
					redirect_to purchase_path
					# Phaseline 3 is hard coded into the form in the view of the purchase_path
					# I don't think that this should stay this way.
					# I imagine the more intelligent approach would be to abstract it out further
				when "3"
					redirect_to payment_path(test_program_visit: true)
				end
			else
				redirect_to self.send(resolve_path(@test_visit.test_version))
			end
		else
			redirect_to root_url
		end
	end

	private
	def resolve_path(test_version)
		case test_version
		when "1"
			return "a_path"
		when "2"
			return "b_path"
		when "3"
			return "c_path"
		end
	end
end