class Client < User
  
  def admin?
    false
  end
  
  def client?
    true
  end
  
  def contributor?
    false
  end
end