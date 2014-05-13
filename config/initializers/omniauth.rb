OmniAuth.config.logger = Rails.logger

OmniAuth.config.on_failure = Proc.new { |env| 
    OmniAuth::FailureEndpoint.new(env).redirect_to_failure
   }

Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.production?
    provider :facebook, '657512180934505', 'ba2bce51473acb13c1b46a348d869392', scope: "email,publish_actions"
  elsif Rails.env.staging?
    provider :facebook, '776372492381806', 'd752c0e78f2cc749749433a1d29f604d', scope: "email, publish_actions"
  else
    provider :facebook, "774362285916160", "f6108f85cbc187652240139f061bd0e9", scope: "email, publish_actions"
  end
  provider :twitter, 'KQZXkv7VAiRdU4nVkdrkbw', 'tfITw4tArdJRgwdCzHs8iAwxaQls4wPT7i7vPTCLA'
  provider :identity, :fields => [:email, :name, :user_id], on_failed_registration: lambda { |env|
    env["rack.session"][:identity] = env['omniauth.identity']
    resp = Rack::Response.new("", 302)
    resp.redirect('/access_requests')
    resp.finish
  }
end
