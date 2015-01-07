class Discount < ActiveRecord::Base
  attr_accessible :amount, :campaign_name, :end_date, :genre, :start_date, :discount_code

	validates_uniqueness_of :discount_code
	validates_uniqueness_of :campaign_name

	def apply_discount(purchase_price)
		if Time.now.to_date > self.end_date
			return [purchase_price, "Discount is no longer Valid. The end of the discount period was: #{self.end_date.to_formatted_s(:long)}"]
		else
			case self.genre
			when "percent"
				discount_amount = self.amount * purchase_price
			when "fixed"
				discount_amount = self.amount
			else
				discount_amount = self.amount * purchase_price
			end
			new_price = purchase_price - discount_amount
			return [new_price.to_i, "Discount Successfully Applied"]
		end
	end

	def show_amount
		case self.genre
		when "percent"
			amount = (self.amount * 100).to_s + "%"
		when "fixed"
			amount = "$" + self.amount.to_s
		else
			amount = (self.amount * 100).to_s + "%"
		end

		return amount
	end

	def show_start_date
		self.start_date.to_formatted_s(:long)
	end

	def show_end_date
		self.end_date.to_formatted_s(:long)
	end
end
