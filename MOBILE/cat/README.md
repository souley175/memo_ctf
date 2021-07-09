lien utile :
https://blog.bssi.fr/write-up-du-ctf-android/

BACKUP-01

dd if=cat.ab bs=1 skip=24 | python -c "import zlib,sys;sys.stdout.write(zlib.decompress(sys.stdin.read()))" > backup.tar