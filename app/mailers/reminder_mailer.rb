class ReminderMailer < ActionMailer::Base
  default from: "hello@capstory",
          reply_to: "hello@capstory.com"
          
  def reminder_confirmation(reminder)
    @reminder = reminder
    
    mail(to: @reminder.email, subject: "We've Schedule Your Reminder")
  end
end