class DayTwoReminder
  @queue = :day_two_reminders_queue
  
  def self.perform
    @post = Post.last
    puts "Hello world, this is Day Two Reminder"
    puts "#{@post.email} is the email from which the post was sent"
    
  end
  
end