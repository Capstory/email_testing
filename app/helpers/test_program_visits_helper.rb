module TestProgramVisitsHelper
	def version_filter(visits_array, test_version_sought)
		filtered = visits_array.select do |v|
			v.test_version.to_i == test_version_sought
		end
		return filtered
	end

	def phaseline_filter(visits_array, phaseline_sought)
		filtered = visits_array.select do |v|
			case phaseline_sought
			when 1
				v.phaseline_one == true
			when 2
				v.phaseline_two == true
			when 3
				v.phaseline_three == true
			else
				raise NoPhaselineError
			end
		end
		return filtered
	end
	
end