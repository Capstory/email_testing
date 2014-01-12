class RafflingMailer < ActionMailer::Base
  def notify_winners(winner, capsule_email, capsule_link)
    @winner_email = winner
    @capsule_email = capsule_email
    @url = capsule_link.is_a?(String) ? "http://www.capstory.me/" + capsule_link : "http://www.capstory.me/capsules/" + capsule_link.to_s
    
    mail(from: @capsule_email, reply_to: @capsule_email, to: @winner_email, subject: "You've Won!")
  end
  
  def notify_admins(winners, capsule_email)
    @winners_array = winners
    @capsule_email = capsule_email
    
    mail(from: @capsule_email, reply_to: "brad@capstory.me", to: ['brad@capstory.me', 'suprasanna@capstory.me', 'jocelyn@capstory.me', 'dustin@capstory.me'], subject: "Raffle Winners")
  end
end