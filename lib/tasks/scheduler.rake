desc "Automatically retrieve emails"
task :get_new_emails => :environment do
  Resque.enqueue(EmailEngine)
end

desc "Send Out Reminder Emails"
task :send_reminders => :environment do
  reminders = Reminder.all
  num_sent = 0
  reminders.each do |reminder|
    if reminder.reminder_sent == false && reminder.date_to_remind.to_date == Date.today
      ReminderMailer.send_reminder(reminder).deliver
      reminder.reminder_sent = true
      reminder.save
      num_sent += 1
    end
  end
  puts "#{num_sent} reminders were sent"
end

desc "One-time update to all the reminders on the system"
task :set_reminders_to_false => :environment do
  reminders = Reminder.all
  reminders.each do |reminder|
    if reminder.reminder_sent.nil?
      reminder.reminder_sent = false
      reminder.save
    end
  end
end


desc "Send Emails to Submitters after 48hrs"
task :day_two_reminder => :environment do
  @capsules = Capsule.all
  @capsules.each do |capsule|
    if capsule.event_date.nil?
      next
    elsif capsule.event_date < 1.days.ago.to_date && capsule.event_date > 3.days.ago.to_date
      # Enter code here for searching through the photo submiters
      if capsule.posts.empty?
        puts "There are no photos in capsule name: #{capsule.name}"
      else

        senders = capsule.posts.pluck(:email).compact.uniq
        senders.each do |sender|
          PostMailer.day_two_reminder(sender, capsule.email, capsule.named_url).deliver
        end
      end
    else
      next
    end
  end
end

desc "Send out an Email after an event"
task :post_event_blast, [:capsule_email] => [:environment] do |t, args|
  @capsule = Capsule.find_by_email(args[:capsule_email])
  if @capsule
    senders = @capsule.posts.pluck(:email).compact.uniq
    senders.each do |sender|
      PostMailer.post_event_blast(sender, @capsule.email, @capsule.named_url).deliver
      puts "Message sent to #{sender}"
      puts "-------------------------"
    end
  else
    raise "No such capsule. Please verify the name and try again."
  end
end

desc "ISSE Post Day 1 SMS"
task :isse_day_one => :environment do
  capsule = Capsule.find_by_email("isse@capstory.me")
  senders = capsule.posts.pluck(:email).compact.uniq
  senders.each do |sender|
    PostMailer.isse_day_one(sender).deliver
  end
end

desc "ISSE Post Day 2 SMS"
task :isse_day_two => :environment do
  capsule = Capsule.find_by_email("isse@capstory.me")
  senders = capsule.posts.pluck(:email).compact.uniq
  senders.each do |sender|
    PostMailer.isse_day_two(sender).deliver
  end
end

desc "ISSE Post Day 3 SMS"
task :isse_day_three => :environment do
  capsule = Capsule.find_by_email("isse@capstory.me")
  senders = capsule.posts.pluck(:email).compact.uniq
  senders.each do |sender|
    PostMailer.isse_day_three(sender).deliver
  end
end