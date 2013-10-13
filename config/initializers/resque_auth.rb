Resque::Server.use(Rack::Auth::Basic) do |user, password|
  password == "foobar1234"
end