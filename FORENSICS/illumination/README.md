consigne du ctf :

Un développeur junior vient de passer à une nouvelle plateforme de contrôle de source. Pouvez-vous trouver le jeton secret ? 

decode base64 :

UmVkIEhlcnJpbmcsIHJlYWQgdGhlIEpTIGNhcmVmdWxseQ==
result : Red Herring, read the JS carefully

cd /home/kali/CTF/HTB/FORENSICS/illumination/Illumination.JS/.git/logs
cat HEAD
unique token : 47241a47f62ada864ec74bd6dedc4d33f4374699

decode base64 token :
SFRCe3YzcnNpMG5fYzBudHIwbF9hbV9JX3JpZ2h0P30=
result : HTB{v3rsi0n_c0ntr0l_am_I_right?}