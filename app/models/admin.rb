class Admin < User
  attr_accessible :user_id
  
  def admin?
    true
  end
  
  def client?
    false
  end
  
  def contributor?
    false
  end

end