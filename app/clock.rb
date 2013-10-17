require File.join(File.dirname(__FILE__), '..', 'config', 'boot')
require File.join(File.dirname(__FILE__), '..', 'config', 'environment')

include Clockwork

handler do |job|
  
  Resque.enqueue(EmailEngine, 6, "sarahandjohnswedding@routinehub.com")
end

every(10.seconds, "Trying to fetch new emails")