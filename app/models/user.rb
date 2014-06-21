class User < ActiveRecord::Base
  attr_accessible :name, :email
  
  has_many :authorizations
  has_many :encapsulations
  has_many :capsules, through: :encapsulations
  
  def self.create_from_hash!(hash)
    create(:name => hash[:info][:name])
  end
  
  def facebook_authorized?
    providers = self.authorizations.pluck(:provider)
    providers.include?("facebook")
  end
  
  def fb_provider
    "facebook"
  end
  
  def facebook_token
    # May need to adapt the 'first' call at the end of the line below
    # I don't think this would be an issue because you can't register multiple facebook accounts
    # However, there is always the possible of an edge case bug creeping in
    fb_auth = self.authorizations.where(provider: "facebook").first
    return fb_auth.oauth_token
  end
  
  def facebook
    @facebook ||= Koala::Facebook::API.new(self.facebook_token)
  end
  
  def fb_uid
    self.authorizations.find_by_provider("facebook").uid
  end
  
  def identity_auth
    return self.authorizations.where(provider: "identity").first
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
  
	def admin?
		if self.class == Admin
			return true
		else
			return false
		end
	end

	def client?
		if self.class == Client
			return true
		else
			return false
		end
	end

	def contributor?
		if self.class == Contributor
			return true
		else
			return false
		end
	end

	def vendor?
		if self.class == Vendor
			return true
		else
			return false
		end
	end
end
