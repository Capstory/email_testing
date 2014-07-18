class AccessRequest < ActiveRecord::Base
  attr_accessible :email, :event_address, :name, :event_date, :request_status, :source, :partner_code, :industry_role, :questions
  
  validates_presence_of :name
  # validates_presence_of :source
  # validates :industry_role, presence: true, if: :industry_pro?
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  
  def pending?
    if self.request_status == "pending"
      true
    else
      false
    end
  end
  
  def validated?
    if self.request_status == "validated"
      true
    else
      false
    end
  end
  
  def no_status?
    if self.request_status.nil?
      true
    else
      false
    end
  end
  
  def nature_of_request
    case self.source
    when "bride"
      return "Bride/Groom"
    when "vendor"
      return "Industry Professional"
    when "other"
      return "Other"
    else
      return "N/A"
    end
  end
  
  def code
    if self.partner_code.nil? || self.partner_code.empty?
      "N/A"
    else
      self.partner_code
    end
  end
  
  def industry_pro?
    self.source == "vendor"
  end
  
  def questions_comments
    if self.questions.nil? || self.empty?
      "N/A"
    else
      self.questions
    end
  end
end
