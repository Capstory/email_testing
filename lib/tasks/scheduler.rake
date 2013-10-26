desc "Automatically retrieve emails"
task :get_new_emails => :environment do
  Resque.enqueue(EmailEngine, 7, "reynoldslovestory@capstory.me")
  Resque.enqueue(EmailEngine, 8, "demo@capstory.me")
end