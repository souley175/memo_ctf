sujet :

There is a sysadmin, who has been dumping all the USB events on his Linux host all the year... Recently, some bad guys managed to steal some data from his machine when they broke into the office. Can you help him to put a tail on the intruders? Note: once you find it, "crack" it. 

lien utile :

https://korben.info/usbrip-surveillez-les-insertions-de-peripheriques-usb-cle-etc-sur-vos-machines-linux.html

#outils usbrip

info violations :

*] Started at 2021-07-10 13:41:46
[13:41:46] [INFO] Reading "/home/kali/CTF_HTB/FORENSICS/usb_ripper/usb-ripper/syslog"
[13:41:57] [INFO] Opening authorized device list: "/home/kali/CTF_HTB/FORENSICS/usb_ripper/usb-ripper/auth.json"
[13:41:58] [INFO] Searching for violations
[?] How would you like your violation list to be generated?
                                                                                                                  
    1. JSON-file                                                                                                  
    2. Terminal stdout

[>] Please enter the number of your choice: 2
[13:51:08] [INFO] Preparing gathered events
[13:51:08] [WARNING] Terminal window is too small to display table properly
[13:51:08] [WARNING] Representation: List

USB-Violation-Events                                                                                              
−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
•••••••••••••••••••• Aug  3 ••••••••••••••••••••
−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
Connected:      Aug  3 07:18:01
User:           kali
VID:            3993
PID:            9324
Product:        1F8ADAEE73D993944FC7C7783
Manufacturer:   884CCC9A3DF08F49C621373E
Serial Number:  71DF5A33EFFDEA5B1882C9FBDC1240C6
Bus-Port:       1-1
Disconnected:   Aug  3 07:18:10
−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
[*] Shutted down at 2021-07-10 13:51:08
[*] Time taken: 0:09:21.554755

decode md5 :   71DF5A33EFFDEA5B1882C9FBDC1240C6

result : mychemicalromance donc le flag HTB{mychemicalromance}

