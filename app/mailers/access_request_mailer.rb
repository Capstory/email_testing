class AccessRequestMailer < ActionMailer::Base
  default from: "support@capstory.me"
  
  def welcome_email(access_request)
    @access_request = access_request
    mail(to: @access_request.email, subject: "Your Request Confirmation")
  end
  
  def admin_notification(access_request)
    @access_request = access_request
    @url = "http://www.capstory.me/access_requests"
    mail(to: 'brad@capstory.me', subject: "#{@access_request.name} has requested access to Capstory.me")
  end
end
