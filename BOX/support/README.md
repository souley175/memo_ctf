# ip machine windows
10.10.11.174

# nmap result
Starting Nmap 7.92 ( https://nmap.org ) at 2022-10-09 12:25 EDT
Nmap scan report for 10.10.11.174
Host is up (0.092s latency).
Not shown: 990 filtered tcp ports (no-response)
PORT     STATE SERVICE       VERSION
53/tcp   open  domain        Simple DNS Plus
88/tcp   open  kerberos-sec  Microsoft Windows Kerberos (server time: 2022-10-09 16:26:11Z)
135/tcp  open  msrpc         Microsoft Windows RPC
139/tcp  open  netbios-ssn   Microsoft Windows netbios-ssn
389/tcp  open  ldap          Microsoft Windows Active Directory LDAP (Domain: support.htb0., Site: Default-First-Site-Name)
445/tcp  open  microsoft-ds?
593/tcp  open  ncacn_http    Microsoft Windows RPC over HTTP 1.0
636/tcp  open  tcpwrapped
3268/tcp open  ldap          Microsoft Windows Active Directory LDAP (Domain: support.htb0., Site: Default-First-Site-Name)
3269/tcp open  tcpwrapped
Service Info: Host: DC; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| smb2-time: 
|   date: 2022-10-09T16:26:20
|_  start_date: N/A
| smb2-security-mode: 
|   3.1.1: 
|_    Message signing enabled and required

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 77.89 seconds

# url wsman
http://10.10.11.174:5985/wsman

# domain sid
Domain Sid: S-1-5-21-1677581083-3380853377-188903654

# dnspy ldapsearch

# check list file
smbclient -L 10.10.11.174

# extract file smb
smbclient //10.10.11.174/support-tools -N -c 'prompt OFF; recurse ON; lcd  ./smb/;mget *'

#dnspy info :

private static string enc_password = "0Nv32PTwgYjzg9/8j5TbmvPd3e7WhtWWyuPsyO76/Y+U193E";
private static byte[] key = Encoding.ASCII.GetBytes("armando");

function encrypted password :

namespace UserInfo.Services
{
	// Token: 0x02000006 RID: 6
	internal class Protected
	{
		// Token: 0x0600000F RID: 15 RVA: 0x00002118 File Offset: 0x00000318
		public static string getPassword()
		{
			byte[] array = Convert.FromBase64String(Protected.enc_password);
			byte[] array2 = array;
			for (int i = 0; i < array.Length; i++)
			{
				array2[i] = (array[i] ^ Protected.key[i % Protected.key.Length] ^ 223);
			}
			return Encoding.Default.GetString(array2);
			}
		}	
}

using System;
using System.Text;
					
public class Program
{      	     
	public static void Main()
	{
		string enc_password = "0Nv32PTwgYjzg9/8j5TbmvPd3e7WhtWWyuPsyO76/Y+U193E";
    	byte[] key = Encoding.ASCII.GetBytes("armando");
		
		byte[] numArray = Convert.FromBase64String(enc_password);
      	byte[] bytes = numArray;
      for (int index = 0; index < numArray.Length; ++index)
        bytes[index] = (byte) ((int) numArray[index] ^ (int) key[index % key.Length] ^ 223);
      Console.WriteLine(Encoding.Default.GetString(bytes));
	}
}

# function decrypt :



# password : nvEfEK16^1aM4$e7AclUf8x$tRWxPWO1%lmz