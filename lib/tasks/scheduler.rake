desc "Automatically retrieve emails"
task :get_new_emails => :environment do
  Resque.enqueue(EmailEngine, 6, "sarahandjohnswedding@routinehub.com")
end