desc "Declare Raffle Winner"
task :choose_winner, [:capsule_name] => [:environment] do |t, args|
  raffle = Raffling.new(args[:capsule_name])
  raffle.conduct
  
  raffle.show_winners
  
  raffle.notifications
end