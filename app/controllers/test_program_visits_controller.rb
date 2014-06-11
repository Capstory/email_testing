class TestProgramVisitsController < ApplicationController

	def index
		@visits = TestProgramVisit.all
	end

	def create
		unless cookies[:test_program_visit]
			test = TestProgramVisit.create do |v|
				v.ip_address = request.env["REMOTE_ADDR"]
				v.test_version = params[:test_version]
				v.phaseline_one = false
				v.phaseline_two = false
				v.phaseline_three = false
			end
			cookies[:test_program_visit] = { value: JSON.generate([request.env["REMOTE_ADDR"], test.id]), expires: 3.hours.from_now }
		end
		redirect_to self.send(resolve_path({ test_version: params[:test_version], target: "root" }))
	end

	def update
		if cookies[:test_program_visit]
			cookie_value = JSON.parse(cookies[:test_program_visit])
			test_visit = TestProgramVisit.find_by_ip_address_and_id(cookie_value.first, cookie_value.last)
			test_visit.resolve_phaseline(params[:phaseline])
		end
		path = resolve_path({target: "phaseline", phaseline: params[:phaseline]})
		redirect_to self.send(path)
	end

	def admin_reset_cookie
		if cookies[:test_program_visit]
			cookies.delete :test_program_visit
		end
		redirect_to root_url
	end

	private
	def resolve_path(options={})
		if options[:target] == "root"
			case options[:test_version]
			when "1"
				return "a_path"
			when "2"
				return "b_path"
			when "3"
				return "c_path"
			end
		elsif options[:target] == "phaseline"
			# tpv = cookies[:test_program_visit].nil? ? false : true
			case options[:phaseline]
			when "1"
				return "pricing_path"
			when "2"
				return "purchase_path"
				# Phaseline 3 is hard coded into the form in the view of the purchase_path
				# I don't think that this should stay this way.
				# I imagine the more intelligent approach would be to abstract it out further
			when "3"
				return "payment_path"
			end
		else
			return "root_url"
		end
	end
end