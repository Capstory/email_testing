desc "Automatically retrieve emails"
task :get_new_emails => :environment do
  Resque.enqueue(EmailEngine, 7, "reynoldslovestory@capstory.me")
end