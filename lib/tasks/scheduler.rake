desc "Automatically retrieve emails"
task :get_new_emails => :environment do
  Resque.enqueue(EmailEngine)
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