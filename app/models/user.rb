class User < ActiveRecord::Base
  attr_accessible :name
  
  has_many :authorizations
  
  def self.create_from_hash!(hash)
    create(:name => hash[:info][:name])
  end
  
  # def self.from_omniauth(auth)
  #     where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
  #       user.provider = auth.provider
  #       user.uid = auth.uid
  #       user.name = auth.info.name
  #       user.oauth_token = auth.credentials.token
  #       user.oauth_expires_at = Time.at(auth.credentials.expires_at) if auth.provider == "facebook"
  #       user.save!
  #     end
  #   end
end
