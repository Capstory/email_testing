OmniAuth.config.logger = Rails.logger

OmniAuth.config.on_failure = Proc.new { |env| 
    OmniAuth::FailureEndpoint.new(env).redirect_to_failure
   }

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '657512180934505', 'ba2bce51473acb13c1b46a348d869392'
  provider :twitter, 'KQZXkv7VAiRdU4nVkdrkbw', 'tfITw4tArdJRgwdCzHs8iAwxaQls4wPT7i7vPTCLA'
  provider :identity, :fields => [:email, :name, :genre], on_failed_registration: lambda { |env|
    env["rack.session"][:identity] = env['omniauth.identity']
    resp = Rack::Response.new("", 302)
    resp.redirect('/access_requests')
    resp.finish
  }
end