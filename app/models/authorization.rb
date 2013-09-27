class Authorization < ActiveRecord::Base
  attr_accessible :provider, :uid, :user_id, :oauth_token, :oauth_expires_at
  
  belongs_to :user
  validates_presence_of :user_id, :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider
  
  def self.find_from_hash(hash)
    find_by_provider_and_uid(hash[:provider], hash[:uid])
  end
  
  def self.create_from_hash(hash, user = nil)
    user ||= User.create_from_hash!(hash)
    Authorization.create do |auth|
      auth.user_id = user.id
      auth.uid = hash[:uid] 
      auth.provider = hash[:provider]
      auth.oauth_token = hash[:credentials][:token]
      auth.oauth_expires_at = Time.at(hash[:credentials][:expires_at]) if hash[:provider] == 'facebook'
      auth.save!
    end
  end
  
end
