# ip
10.10.11.230

# subdomains enum
wfuzz --hh 178 -c -w ../../../SecLists/Discovery/DNS/subdomains-top1million-110000.txt -H "HOST:FUZZ.cozyhosting.htb" http://cozyhosting.htb

# md5 decode
emerald

# http://cozyhosting.htb/actuator/sessions
{
  "7D2192D811A669B98DD57AF2FA4B7757": "kanderson",
  "1B1254850D46E07AC5900D3E7BA79FBD": "UNAUTHORIZED"
}

# modifier JSESSIONID puis go sur la page login admin
http://cozyhosting.htb/admin