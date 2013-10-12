class Contributor < User

  def admin?
    false
  end
  
  def client?
    false
  end
  
  def contributor?
    true
  end
end