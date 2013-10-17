
require 'clockwork'

include Clockwork

every(30.seconds, "Queueing Email Retreiver Job") { Resque.enqueue(EmailEngine, 6, "sarahandjohnswedding@routinehub.com") }