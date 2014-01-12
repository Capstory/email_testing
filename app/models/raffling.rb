class Raffling
  attr_accessor :capsule_email, :winners, :pool
  def initialize(capsule_email=nil)
    @capsule_email = capsule_email
    @winners = []
    @pool = []
  end
  
  def capsule_exists?
    Capsule.exists?(email: self.capsule_email)
  end
  
  def retrieve_capsule
    @capsule = Capsule.find_by_email(self.capsule_email)
  end
  
  def create_pool
    if self.capsule_exists?
      posts = self.retrieve_capsule.posts
    else
      if Rails.env.production?
        raise "There is no such capsule. Try again with another one capsule."
      else
        posts = Post.all
      end
    end
    posts.each { |post| self.pool << post.email }
    self.pool.compact!
  end
  
  def conduct
    self.create_pool
    until self.winners.length > 1
      winner = self.pool.sample
      unless self.winners.include?(winner)
        self.winners << winner
      else
        next
      end
    end
  end
  
  def show_winners
    puts "Raffle Capsule: #{self.capsule_email}"
    self.winners.each_with_index do |winner, index|
      puts "Winner #{index + 1} -> #{winner}"
    end
  end
  
  def notify_admins
    RafflingMailer.notify_admins(self.winners, self.capsule_email).deliver
  end
  
  def notifications
    # Notification of winners will be done manually.
    # We may revisit this feature in the future.
    # self.notify_winners
    self.notify_admins
  end
end