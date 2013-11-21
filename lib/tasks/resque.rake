require 'resque/tasks'
require 'resque_scheduler/tasks'

task "resque:setup" => :environment do
  require 'resque'
  require 'resque_scheduler'
  require 'resque/scheduler'
  
  Resque.schedule = YAML.load_file(Rails.root.join("config","resque_scheduled_tasks.yml"))
  
  ENV['QUEUE'] = '*'
  
  Dir["#{Rails.root}/app/workers/*.rb"].each { |file| require file }
end