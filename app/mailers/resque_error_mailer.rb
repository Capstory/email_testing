class ResqueErrorMailer < ActionMailer::Base
  default to: ["brad@prudl.com", "suprasanna@capstory.me", "dustin@capstory.me"],
          from: "admin@capstory.me"
          
  def send_notification
    mail(subject: "Potential Background Job Problem")
  end
end