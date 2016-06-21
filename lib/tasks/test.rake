require 'rest-client'

desc "Authenticates admin user and tests api endpoints"
task authenticate_and_test: :environment do
  auth_url = "http://admin:trycatch@#{ENV['host']}/auth/sign_in"
  response = RestClient.post( auth_url , email: 'admin@test.com', password: "trycatch", password_confirmation: "trycatch")
  selected_headers = response.headers.slice( :access_token , :token_type, :client, :expiry, :uid)

  mindmaps_url = "http://admin:trycatch@#{ENV['host']}/api/v1/mindmaps"
  p response = RestClient.get(mindmaps_url , selected_headers)

  ideas_url = "http://admin:trycatch@#{ENV['host']}/api/v1/ideas"
  p response = RestClient.get(ideas_url , selected_headers)
end
