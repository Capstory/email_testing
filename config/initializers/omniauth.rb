OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do

  provider :twitter, 'KQZXkv7VAiRdU4nVkdrkbw', 'tfITw4tArdJRgwdCzHs8iAwxaQls4wPT7i7vPTCLA'
end