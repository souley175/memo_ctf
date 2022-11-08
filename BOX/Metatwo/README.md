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