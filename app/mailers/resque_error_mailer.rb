class ResqueErrorMailer < ActionMailer::Base
  default to: "brad@prudl.com",
          from: "admin@capstory.me"
          
  def send_notification
    mail(subject: "Potential Background Job Problem")
  end
end