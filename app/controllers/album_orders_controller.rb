class AlbumOrdersController < ApplicationController
	def quantity
		
	end

	def billing
				
	end
	

	def northpointe
		if Rails.env.production?
			@capsule_names = {
				"Star" => "star", 
				"Tiny Mini" => "tinymini", 
				"Shining Star" => "shiningstar", 
				"Super Star" => "superstar", 
				"Northpointe Dance" => "northpointedance", 
				"Stellar" => "stellar", 
				"Select Supreme" => "selectsupreme", 
				"Premier" => "premier"
			}
		else
			@capsule_names = {
				"My Capsule" => "submit", 
				"An Awesome Cap" => "awesomecap",
				"Makarov's Capsule" => "makarov"
			}
		end
	end
end
