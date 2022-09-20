# machine windows

# 10.10.11.152

# nmap simple

nmap 10.10.11.152 -Pn 
Starting Nmap 7.92 ( https://nmap.org ) at 2022-08-13 10:53 EDT
Nmap scan report for 10.10.11.152
Host is up (0.079s latency).
Not shown: 993 filtered tcp ports (no-response)
PORT     STATE SERVICE
88/tcp   open  kerberos-sec
389/tcp  open  ldap
464/tcp  open  kpasswd5
593/tcp  open  http-rpc-epmap
636/tcp  open  ldapssl
3268/tcp open  globalcatLDAP
3269/tcp open  globalcatLDAPssl

Nmap done: 1 IP address (1 host up) scanned in 38.33 seconds

# nmap flag
