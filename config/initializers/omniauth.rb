OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '657512180934505', 'ba2bce51473acb13c1b46a348d869392'
  provider :twitter, 'KQZXkv7VAiRdU4nVkdrkbw', 'tfITw4tArdJRgwdCzHs8iAwxaQls4wPT7i7vPTCLA'
  provider :identity, :fields => [:email, :name, :genre]
end