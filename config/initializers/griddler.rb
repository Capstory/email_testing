Griddler.configure do |config|
 config.processor_class = EmailProcessor
 config.to = :hash
 config.from = :email
 config.email_service = :sendgrid 
end