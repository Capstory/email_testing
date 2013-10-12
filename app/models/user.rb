class User < ActiveRecord::Base
  attr_accessible :name, :email
  
  has_many :authorizations
  has_many :encapsulations
  has_many :capsules, through: :encapsulations
  
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
  
  def self.capsule_owner?(capsule_id)
    @encapsulation = Encapsulation.find_by user_id: self.id, capsule_id: capsule_id
    @encapsulation.owner ? true : false
  end
end
