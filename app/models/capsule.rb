class Capsule < ActiveRecord::Base
  attr_accessible :name, :email, :event_date, :named_url, :response_message, :requires_verification
  
  has_many :encapsulations
  has_many :users, through: :encapsulations

  has_many :posts
	has_one :logo, as: :logoable
	
	validates :name, presence: true
	validates :email, presence: true
	# validates :event_date, presence: true	
  validates_uniqueness_of :email
  # validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
	
  
  extend FriendlyId
  friendly_id :named_url
  
	def self.posts_avg(capsules)
		posts_count = capsules.map { |capsule| capsule.posts.count }
		result = posts_count.reduce(:+) / capsules.count
		return result
	end

	def self.posts_min(capsules)
		posts_count = capsules.map { |capsule| capsule.posts.count }
		return posts_count.min
	end

	def self.posts_max(capsules)
		posts_count = capsules.map { |capsule| capsule.posts.count }
		return posts_count.max
	end

	def self.contributors_avg(capsules)
		contributors_count = capsules.map { |capsule| capsule.contributors_count }			
		result = contributors_count.reduce(:+) / capsules.count
		return result
	end

	def self.contributors_min(capsules)
		contributors_count = capsules.map { |capsule| capsule.contributors_count }			
		return contributors_count.min
	end

	def self.contributors_max(capsules)
		contributors_count = capsules.map { |capsule| capsule.contributors_count }			
		return contributors_count.max
	end

	def self.usage_avg(capsules)
		usage_array = capsules.map { |capsule| capsule.usage_range }
		numerator = usage_array.reduce(:+) / capsules.count
		return numerator
	end

	def self.usage_min(capsules)
		usage_array = capsules.map { |capsule| capsule.usage_range }
		return usage_array.min
	end

	def self.usage_max(capsules)
		usage_array = capsules.map { |capsule| capsule.usage_range }
		return usage_array.max
	end

	def self.admins
		self.all.select do |capsule|
			capsule.owner != "N/A" && capsule.owner.type == "Admin"
		end
	end

	def self.clients
		self.all.select do |capsule|
			capsule.owner != "N/A" && capsule.owner.type == "Client"
		end
	end

	def has_pin?
		if self.pin_code.nil?
			return false
		else
			return true
		end
	end

  def owners_name
    owner = self.encapsulations.where(owner: true)
    if owner.empty?
      return "N/A"
    else
      return owner.first.user.name
    end
  end
  
  def owner
    owner = self.encapsulations.where(owner: true)
    if owner.empty?
      return "N/A"
    else
      return owner.first.user
    end
  end

	def accepting_submissions?
		locked ? false : true
	end

	def has_logo?
		!self.logo.blank?
	end

	def contributors
		contributors = self.posts.map { |p| p.email }
		return contributors.uniq
	end

	def contributors_count
		self.contributors.count
	end

	def usage_range
		case self.posts.count
		when 0
			return 0
		when 1
			return 1
		else
			dates = self.posts.map { |p| p.created_at }
			diff = dates.max - dates.min
			return (diff / 1.day).to_i
		end
	end
end
