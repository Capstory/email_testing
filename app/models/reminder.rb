class Reminder < ActiveRecord::Base
  attr_accessible :date, :email
  
  validates_presence_of :date
  validates_presence_of :email
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  
  def date_to_remind
    case self.date
    when "3_days"
      return self.created_at + 3.days
    when "1_week"
      return self.created_at + 1.week
    when "2_weeks"
      return self.created_at + 2.weeks
    when "1_month"
      return self.created_at + 1.month
    when "2_months"
      return self.created_at + 2.months
    else
      return self.created_at + 1.month
    end
  end
end
