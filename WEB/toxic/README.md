-web-cache poisoning peut etre XSS

URL :

https://portswigger.net/web-security/web-cache-poisoning

scan 1 :

sudo nmap -sS -T4 -sV -sC -v 206.189.121.131                                                            130 ⨯
Starting Nmap 7.91 ( https://nmap.org ) at 2021-05-02 20:39 EDT
NSE: Loaded 153 scripts for scanning.
NSE: Script Pre-scanning.
Initiating NSE at 20:39
Completed NSE at 20:39, 0.00s elapsed
Initiating NSE at 20:39
Completed NSE at 20:39, 0.00s elapsed
Initiating NSE at 20:39
Completed NSE at 20:39, 0.00s elapsed
Initiating Ping Scan at 20:39
Scanning 206.189.121.131 [4 ports]
Completed Ping Scan at 20:39, 0.03s elapsed (1 total hosts)
Initiating Parallel DNS resolution of 1 host. at 20:39
Completed Parallel DNS resolution of 1 host. at 20:39, 6.53s elapsed
Initiating SYN Stealth Scan at 20:39
Scanning 206.189.121.131 [1000 ports]
Discovered open port 143/tcp on 206.189.121.131
Discovered open port 8080/tcp on 206.189.121.131
Discovered open port 110/tcp on 206.189.121.131
Discovered open port 80/tcp on 206.189.121.131
Discovered open port 25/tcp on 206.189.121.131
Discovered open port 993/tcp on 206.189.121.131
Discovered open port 587/tcp on 206.189.121.131
Discovered open port 995/tcp on 206.189.121.131
Discovered open port 443/tcp on 206.189.121.131
Discovered open port 119/tcp on 206.189.121.131
Discovered open port 563/tcp on 206.189.121.131
Discovered open port 465/tcp on 206.189.121.131
Completed SYN Stealth Scan at 20:39, 4.51s elapsed (1000 total ports)
Initiating Service scan at 20:39
Scanning 12 services on 206.189.121.131
Service scan Timing: About 83.33% done; ETC: 20:42 (0:00:31 remaining)
Completed Service scan at 20:42, 166.93s elapsed (12 services on 1 host)
NSE: Script scanning 206.189.121.131.
Initiating NSE at 20:42
Completed NSE at 20:45, 167.69s elapsed
Initiating NSE at 20:45
NSE Timing: About 89.58% done; ETC: 20:49 (0:00:30 remaining)
NSE Timing: About 90.62% done; ETC: 20:50 (0:00:30 remaining)
NSE Timing: About 91.67% done; ETC: 20:51 (0:00:30 remaining)
NSE Timing: About 92.71% done; ETC: 20:51 (0:00:30 remaining)
NSE Timing: About 93.75% done; ETC: 20:53 (0:00:30 remaining)
Completed NSE at 20:56, 701.76s elapsed
Initiating NSE at 20:56
Completed NSE at 20:56, 0.00s elapsed
Nmap scan report for 206.189.121.131
Host is up (0.0080s latency).
Not shown: 988 filtered ports
PORT     STATE SERVICE     VERSION
25/tcp   open  smtp?
| fingerprint-strings: 
|   DNSStatusRequestTCP, DNSVersionBindReqTCP, FourOhFourRequest, GenericLines, GetRequest, HTTPOptions, Help, Kerberos, RPCCheck, RTSPRequest, SMBProgNeg, SSLSessionReq, TLSSessionReq, TerminalServerCookie, X11Probe: 
|_    21 concurrent connection limit in Avast exceeded(pass:0, processes:VirtualBoxVM.exe[50])
|_smtp-commands: Couldn't establish connection on port 25
80/tcp   open  http?
110/tcp  open  pop3?
| fingerprint-strings: 
|   DNSStatusRequestTCP, DNSVersionBindReqTCP, FourOhFourRequest, GetRequest, HTTPOptions, Help, Kerberos, LDAPSearchReq, LPDString, RPCCheck, RTSPRequest, SMBProgNeg, SSLSessionReq, TerminalServerCookie, X11Probe: 
|_    ERR concurrent connection limit in Avast exceeded(pass:0, processes:VirtualBoxVM.exe[50])
119/tcp  open  nntp?
| fingerprint-strings: 
|   DNSStatusRequestTCP, DNSVersionBindReqTCP, FourOhFourRequest, GetRequest, HTTPOptions, Help, Kerberos, LPDString, RPCCheck, RTSPRequest, SMBProgNeg, SSLSessionReq, TLSSessionReq, TerminalServerCookie, X11Probe: 
|_    02 concurrent connection limit in Avast exceeded(pass:0, processes:VirtualBoxVM.exe[50])
143/tcp  open  imap?
| fingerprint-strings: 
|   DNSStatusRequestTCP, DNSVersionBindReqTCP, FourOhFourRequest, GenericLines, HTTPOptions, Help, Kerberos, RPCCheck, RTSPRequest, SMBProgNeg, SSLSessionReq, TLSSessionReq, TerminalServerCookie, X11Probe: 
|_    BYE concurrent connection limit in Avast exceeded(pass:0, processes:VirtualBoxVM.exe[50])
443/tcp  open  https?
465/tcp  open  smtps?
|_smtp-commands: Couldn't establish connection on port 465
563/tcp  open  snews?
587/tcp  open  submission?
| fingerprint-strings: 
|   DNSStatusRequestTCP, DNSVersionBindReqTCP, FourOhFourRequest, GetRequest, HTTPOptions, Hello, Help, Kerberos, RPCCheck, RTSPRequest, SMBProgNeg, SSLSessionReq, TLSSessionReq, TerminalServerCookie, X11Probe: 
|_    21 concurrent connection limit in Avast exceeded(pass:0, processes:VirtualBoxVM.exe[50])
|_smtp-commands: Couldn't establish connection on port 587
993/tcp  open  imaps?
995/tcp  open  pop3s?
8080/tcp open  http-proxy?
5 services unrecognized despite returning data. If you know the service/version, please submit the following fingerprints at https://nmap.org/cgi-bin/submit.cgi?new-service :
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port25-TCP:V=7.91%I=7%D=5/2%Time=608F464B%P=x86_64-pc-linux-gnu%r(Help,
SF:5A,"21\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\
SF:(pass:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(GenericLines,5A
SF:,"21\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(p
SF:ass:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(GetRequest,5A,"21
SF:\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:
SF:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(HTTPOptions,5A,"21\x2
SF:0concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\
SF:x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(RTSPRequest,5A,"21\x20co
SF:ncurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20
SF:processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(RPCCheck,5A,"21\x20concurre
SF:nt\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20proces
SF:ses:VirtualBoxVM\.exe\[50\]\)\r\n")%r(DNSVersionBindReqTCP,5A,"21\x20co
SF:ncurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20
SF:processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(DNSStatusRequestTCP,5A,"21\
SF:x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0
SF:,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(SSLSessionReq,5A,"21\x
SF:20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,
SF:\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(TerminalServerCookie,5A
SF:,"21\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(p
SF:ass:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(TLSSessionReq,5A,
SF:"21\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pa
SF:ss:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(Kerberos,5A,"21\x2
SF:0concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\
SF:x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(SMBProgNeg,5A,"21\x20con
SF:current\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20p
SF:rocesses:VirtualBoxVM\.exe\[50\]\)\r\n")%r(X11Probe,5A,"21\x20concurren
SF:t\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20process
SF:es:VirtualBoxVM\.exe\[50\]\)\r\n")%r(FourOhFourRequest,5A,"21\x20concur
SF:rent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20proc
SF:esses:VirtualBoxVM\.exe\[50\]\)\r\n");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port110-TCP:V=7.91%I=7%D=5/2%Time=608F4649%P=x86_64-pc-linux-gnu%r(GetR
SF:equest,5B,"ERR\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20e
SF:xceeded\(pass:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(HTTPOpt
SF:ions,5B,"ERR\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exc
SF:eeded\(pass:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(RTSPReque
SF:st,5B,"ERR\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20excee
SF:ded\(pass:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(RPCCheck,5B
SF:,"ERR\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(
SF:pass:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(DNSVersionBindRe
SF:qTCP,5B,"ERR\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exc
SF:eeded\(pass:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(DNSStatus
SF:RequestTCP,5B,"ERR\x20concurrent\x20connection\x20limit\x20in\x20Avast\
SF:x20exceeded\(pass:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(Hel
SF:p,5B,"ERR\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceed
SF:ed\(pass:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(SSLSessionRe
SF:q,5B,"ERR\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceed
SF:ed\(pass:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(TerminalServ
SF:erCookie,5B,"ERR\x20concurrent\x20connection\x20limit\x20in\x20Avast\x2
SF:0exceeded\(pass:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(Kerbe
SF:ros,5B,"ERR\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exce
SF:eded\(pass:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(SMBProgNeg
SF:,5B,"ERR\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceede
SF:d\(pass:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(X11Probe,5B,"
SF:ERR\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pa
SF:ss:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(FourOhFourRequest,
SF:5B,"ERR\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded
SF:\(pass:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(LPDString,5B,"
SF:ERR\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pa
SF:ss:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(LDAPSearchReq,5B,"
SF:ERR\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pa
SF:ss:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port119-TCP:V=7.91%I=7%D=5/2%Time=608F4649%P=x86_64-pc-linux-gnu%r(Help
SF:,5A,"02\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded
SF:\(pass:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(GetRequest,5A,
SF:"02\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pa
SF:ss:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(HTTPOptions,5A,"02
SF:\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:
SF:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(RTSPRequest,5A,"02\x2
SF:0concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\
SF:x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(RPCCheck,5A,"02\x20concu
SF:rrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20pro
SF:cesses:VirtualBoxVM\.exe\[50\]\)\r\n")%r(DNSVersionBindReqTCP,5A,"02\x2
SF:0concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\
SF:x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(DNSStatusRequestTCP,5A,"
SF:02\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pas
SF:s:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(SSLSessionReq,5A,"0
SF:2\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass
SF::0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(TerminalServerCookie
SF:,5A,"02\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded
SF:\(pass:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(TLSSessionReq,
SF:5A,"02\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\
SF:(pass:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(Kerberos,5A,"02
SF:\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:
SF:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(SMBProgNeg,5A,"02\x20
SF:concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x
SF:20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(X11Probe,5A,"02\x20concur
SF:rent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20proc
SF:esses:VirtualBoxVM\.exe\[50\]\)\r\n")%r(FourOhFourRequest,5A,"02\x20con
SF:current\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20p
SF:rocesses:VirtualBoxVM\.exe\[50\]\)\r\n")%r(LPDString,5A,"02\x20concurre
SF:nt\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20proces
SF:ses:VirtualBoxVM\.exe\[50\]\)\r\n");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port143-TCP:V=7.91%I=7%D=5/2%Time=608F4649%P=x86_64-pc-linux-gnu%r(Gene
SF:ricLines,5C,"\x20BYE\x20concurrent\x20connection\x20limit\x20in\x20Avas
SF:t\x20exceeded\(pass:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(H
SF:TTPOptions,5C,"\x20BYE\x20concurrent\x20connection\x20limit\x20in\x20Av
SF:ast\x20exceeded\(pass:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r
SF:(RTSPRequest,5C,"\x20BYE\x20concurrent\x20connection\x20limit\x20in\x20
SF:Avast\x20exceeded\(pass:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")
SF:%r(RPCCheck,5C,"\x20BYE\x20concurrent\x20connection\x20limit\x20in\x20A
SF:vast\x20exceeded\(pass:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%
SF:r(DNSVersionBindReqTCP,5C,"\x20BYE\x20concurrent\x20connection\x20limit
SF:\x20in\x20Avast\x20exceeded\(pass:0,\x20processes:VirtualBoxVM\.exe\[50
SF:\]\)\r\n")%r(DNSStatusRequestTCP,5C,"\x20BYE\x20concurrent\x20connectio
SF:n\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20processes:VirtualBoxV
SF:M\.exe\[50\]\)\r\n")%r(Help,5C,"\x20BYE\x20concurrent\x20connection\x20
SF:limit\x20in\x20Avast\x20exceeded\(pass:0,\x20processes:VirtualBoxVM\.ex
SF:e\[50\]\)\r\n")%r(SSLSessionReq,5C,"\x20BYE\x20concurrent\x20connection
SF:\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20processes:VirtualBoxVM
SF:\.exe\[50\]\)\r\n")%r(TerminalServerCookie,5C,"\x20BYE\x20concurrent\x2
SF:0connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20processes:V
SF:irtualBoxVM\.exe\[50\]\)\r\n")%r(TLSSessionReq,5C,"\x20BYE\x20concurren
SF:t\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20process
SF:es:VirtualBoxVM\.exe\[50\]\)\r\n")%r(Kerberos,5C,"\x20BYE\x20concurrent
SF:\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20processe
SF:s:VirtualBoxVM\.exe\[50\]\)\r\n")%r(SMBProgNeg,5C,"\x20BYE\x20concurren
SF:t\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20process
SF:es:VirtualBoxVM\.exe\[50\]\)\r\n")%r(X11Probe,5C,"\x20BYE\x20concurrent
SF:\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20processe
SF:s:VirtualBoxVM\.exe\[50\]\)\r\n")%r(FourOhFourRequest,5C,"\x20BYE\x20co
SF:ncurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20
SF:processes:VirtualBoxVM\.exe\[50\]\)\r\n");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port587-TCP:V=7.91%I=7%D=5/2%Time=608F4649%P=x86_64-pc-linux-gnu%r(Hell
SF:o,5A,"21\x20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceede
SF:d\(pass:0,\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(Help,5A,"21\x
SF:20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,
SF:\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(GetRequest,5A,"21\x20co
SF:ncurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20
SF:processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(HTTPOptions,5A,"21\x20concu
SF:rrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20pro
SF:cesses:VirtualBoxVM\.exe\[50\]\)\r\n")%r(RTSPRequest,5A,"21\x20concurre
SF:nt\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20proces
SF:ses:VirtualBoxVM\.exe\[50\]\)\r\n")%r(RPCCheck,5A,"21\x20concurrent\x20
SF:connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20processes:Vi
SF:rtualBoxVM\.exe\[50\]\)\r\n")%r(DNSVersionBindReqTCP,5A,"21\x20concurre
SF:nt\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20proces
SF:ses:VirtualBoxVM\.exe\[50\]\)\r\n")%r(DNSStatusRequestTCP,5A,"21\x20con
SF:current\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20p
SF:rocesses:VirtualBoxVM\.exe\[50\]\)\r\n")%r(SSLSessionReq,5A,"21\x20conc
SF:urrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20pr
SF:ocesses:VirtualBoxVM\.exe\[50\]\)\r\n")%r(TerminalServerCookie,5A,"21\x
SF:20concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,
SF:\x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(TLSSessionReq,5A,"21\x2
SF:0concurrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\
SF:x20processes:VirtualBoxVM\.exe\[50\]\)\r\n")%r(Kerberos,5A,"21\x20concu
SF:rrent\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20pro
SF:cesses:VirtualBoxVM\.exe\[50\]\)\r\n")%r(SMBProgNeg,5A,"21\x20concurren
SF:t\x20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20process
SF:es:VirtualBoxVM\.exe\[50\]\)\r\n")%r(X11Probe,5A,"21\x20concurrent\x20c
SF:onnection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20processes:Vir
SF:tualBoxVM\.exe\[50\]\)\r\n")%r(FourOhFourRequest,5A,"21\x20concurrent\x
SF:20connection\x20limit\x20in\x20Avast\x20exceeded\(pass:0,\x20processes:
SF:VirtualBoxVM\.exe\[50\]\)\r\n");

NSE: Script Post-scanning.
Initiating NSE at 20:56
Completed NSE at 20:56, 0.00s elapsed
Initiating NSE at 20:56
Completed NSE at 20:56, 0.00s elapsed
Initiating NSE at 20:56
Completed NSE at 20:56, 0.00s elapsed
Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 1048.22 seconds
           Raw packets sent: 1994 (87.704KB) | Rcvd: 68 (2.788KB)

nmap new scan 2 :

nmap -sV --script=vuln -v 206.189.121.131                                                               130 ⨯
Starting Nmap 7.91 ( https://nmap.org ) at 2021-05-02 20:03 EDT
NSE: Loaded 149 scripts for scanning.
NSE: Script Pre-scanning.
Initiating NSE at 20:03
Completed NSE at 20:03, 10.00s elapsed
Initiating NSE at 20:03
Completed NSE at 20:03, 0.00s elapsed
Initiating Ping Scan at 20:03
Scanning 206.189.121.131 [2 ports]
Completed Ping Scan at 20:03, 0.02s elapsed (1 total hosts)
Initiating Parallel DNS resolution of 1 host. at 20:03
Completed Parallel DNS resolution of 1 host. at 20:03, 6.53s elapsed
Initiating Connect Scan at 20:03
Scanning 206.189.121.131 [1000 ports]
Discovered open port 995/tcp on 206.189.121.131
Discovered open port 110/tcp on 206.189.121.131
Discovered open port 143/tcp on 206.189.121.131
Discovered open port 993/tcp on 206.189.121.131
Discovered open port 25/tcp on 206.189.121.131
Discovered open port 80/tcp on 206.189.121.131
Discovered open port 8080/tcp on 206.189.121.131
Discovered open port 443/tcp on 206.189.121.131
Discovered open port 587/tcp on 206.189.121.131
Discovered open port 119/tcp on 206.189.121.131
Discovered open port 465/tcp on 206.189.121.131
Discovered open port 563/tcp on 206.189.121.131
Completed Connect Scan at 20:03, 4.62s elapsed (1000 total ports)
Initiating Service scan at 20:03
Scanning 12 services on 206.189.121.131
Service scan Timing: About 8.33% done; ETC: 20:17 (0:12:39 remaining)
Completed Service scan at 20:32, 1724.50s elapsed (12 services on 1 host)
NSE: Script scanning 206.189.121.131.
Initiating NSE at 20:32
NSE: [firewall-bypass] lacks privileges.
Completed NSE at 20:39, 409.53s elapsed
Initiating NSE at 20:39
NSE: [tls-ticketbleed] Not running due to lack of privileges.
NSE: [ssl-ccs-injection] No response from server: TIMEOUT
NSE: [ssl-ccs-injection] No response from server: TIMEOUT
NSE: [ssl-ccs-injection] No response from server: TIMEOUT
NSE: [ssl-ccs-injection] No response from server: TIMEOUT
NSE: [ssl-ccs-injection] No response from server: TIMEOUT
NSE Timing: About 78.79% done; ETC: 20:41 (0:00:30 remaining)
NSE Timing: About 80.30% done; ETC: 20:42 (0:00:36 remaining)
NSE Timing: About 81.82% done; ETC: 20:43 (0:00:40 remaining)
NSE Timing: About 83.33% done; ETC: 20:43 (0:00:45 remaining)
NSE Timing: About 87.88% done; ETC: 20:44 (0:00:37 remaining)
Completed NSE at 20:51, 702.18s elapsed
Nmap scan report for 206.189.121.131
Host is up (0.016s latency).
Not shown: 988 filtered ports
PORT     STATE SERVICE     VERSION
25/tcp   open  smtp-proxy  Avast! anti-virus smtp proxy (cannot connect to 206.189.121.131)
| smtp-vuln-cve2010-4344: 
|_  The SMTP server is not Exim: NOT VULNERABLE
|_sslv2-drown: 
80/tcp   open  http?
|_http-aspnet-debug: ERROR: Script execution failed (use -d to debug)
|_http-csrf: Couldn't find any CSRF vulnerabilities.
|_http-dombased-xss: Couldn't find any DOM based XSS.
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
|_http-vuln-cve2014-3704: ERROR: Script execution failed (use -d to debug)
110/tcp  open  pop3-proxy  Avast! anti-virus pop3 proxy (cannot connect to 206.189.121.131)
|_sslv2-drown: 
119/tcp  open  nntp-proxy  Avast! anti-virus NNTP proxy (cannot connect to 206.189.121.131)
|_sslv2-drown: 
143/tcp  open  imap-proxy  Avast! anti-virus IMAP proxy (cannot connect to 206.189.121.131)
|_sslv2-drown: 
443/tcp  open  https?
|_http-aspnet-debug: ERROR: Script execution failed (use -d to debug)
|_http-csrf: Couldn't find any CSRF vulnerabilities.
|_http-dombased-xss: Couldn't find any DOM based XSS.
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
|_http-vuln-cve2014-3704: ERROR: Script execution failed (use -d to debug)
|_ssl-ccs-injection: No reply from server (TIMEOUT)
|_sslv2-drown: 
465/tcp  open  smtps?
|_ssl-ccs-injection: No reply from server (TIMEOUT)
|_sslv2-drown: 
563/tcp  open  snews?
|_ssl-ccs-injection: No reply from server (TIMEOUT)
|_sslv2-drown: 
587/tcp  open  smtp-proxy  Avast! anti-virus smtp proxy (cannot connect to 206.189.121.131)
|_sslv2-drown: 
993/tcp  open  imaps?
|_ssl-ccs-injection: No reply from server (TIMEOUT)
|_sslv2-drown: 
995/tcp  open  pop3s?
|_ssl-ccs-injection: No reply from server (TIMEOUT)
|_sslv2-drown: 
8080/tcp open  http-proxy?
|_http-aspnet-debug: ERROR: Script execution failed (use -d to debug)
|_http-vuln-cve2014-3704: ERROR: Script execution failed (use -d to debug)
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

NSE: Script Post-scanning.
Initiating NSE at 20:51
Completed NSE at 20:51, 0.00s elapsed
Initiating NSE at 20:51
Completed NSE at 20:51, 0.00s elapsed
Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 2858.10 seconds
                                                                      