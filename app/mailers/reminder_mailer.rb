class ReminderMailer < ActionMailer::Base
  default from: "hello@capstory",
          reply_to: "hello@capstory.com"
          
  def reminder_confirmation(reminder)
    @reminder = reminder
    
    mail(to: @reminder.email, subject: "We've Scheduled Your Reminder")
  end
  
  def send_reminder(reminder)
    @reminder = reminder
    
    mail(to: @reminder.email, subject: "A Quick Reminder from Capstory.me")
  end
end