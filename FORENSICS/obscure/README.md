#utilisation keepass2

check l'obfuscation .php puis trouver la stream ds wireshark ou bien avec strings 

strings .pcap | grep FD

cat pass.b64 | base64 -d > pwdb.kdbx    

keepass2john .kdbx > .hash

keepass2john .kdbx

keepass2 .kdbx