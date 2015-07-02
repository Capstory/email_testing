desc "Automatically retrieve emails"
task :get_new_emails => :environment do
  Resque.enqueue(EmailEngine)
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

