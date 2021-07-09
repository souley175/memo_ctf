CHAL IMPOSSIBLE_PASSWORD (section reverse) :

outils :

radawe 2

debut :

strings ./impossible_password.bin

files ./impossible_password.bin

r2 -d ./impossible_password.bin

aaa

s main

pdf

0x0040085d      55             push rbp
│           0x0040085e      4889e5         mov rbp, rsp
│           0x00400861      4883ec50       sub rsp, 0x50
│           0x00400865      897dbc         mov dword [var_44h], edi    ; argc
│           0x00400868      488975b0       mov qword [var_50h], rsi    ; argv
│           0x0040086c      48c745f8700a.  mov qword [var_8h], str.SuperSeKretKey ; 0x400a70 ; "SuperSeKretKey"
│           0x00400874      c645c041       mov byte [var_40h], 0x41    ; 'A' ; 65
│           0x00400878      c645c15d       mov byte [var_3fh], 0x5d    ; ']' ; 93
│           0x0040087c      c645c24b       mov byte [var_3eh], 0x4b    ; 'K' ; 75
│           0x00400880      c645c372       mov byte [var_3dh], 0x72    ; 'r' ; 114
│           0x00400884      c645c43d       mov byte [var_3ch], 0x3d    ; '=' ; 61
│           0x00400888      c645c539       mov byte [var_3bh], 0x39    ; '9' ; 57
│           0x0040088c      c645c66b       mov byte [var_3ah], 0x6b    ; 'k' ; 107
│           0x00400890      c645c730       mov byte [var_39h], 0x30    ; '0' ; 48
│           0x00400894      c645c83d       mov byte [var_38h], 0x3d    ; '=' ; 61
│           0x00400898      c645c930       mov byte [var_37h], 0x30    ; '0' ; 48
│           0x0040089c      c645ca6f       mov byte [var_36h], 0x6f    ; 'o' ; 111
│           0x004008a0      c645cb30       mov byte [var_35h], 0x30    ; '0' ; 48
│           0x004008a4      c645cc3b       mov byte [var_34h], 0x3b    ; orax
│           0x004008a8      c645cd6b       mov byte [var_33h], 0x6b    ; 'k' ; 107
│           0x004008ac      c645ce31       mov byte [var_32h], 0x31    ; '1' ; 49
│           0x004008b0      c645cf3f       mov byte [var_31h], 0x3f    ; '?' ; 63
│           0x004008b4      c645d06b       mov byte [var_30h], 0x6b    ; 'k' ; 107
│           0x004008b8      c645d138       mov byte [var_2fh], 0x38    ; '8' ; 56
│           0x004008bc      c645d231       mov byte [var_2eh], 0x31    ; '1' ; 49
│           0x004008c0      c645d374       mov byte [var_2dh], 0x74    ; 't' ; 116
│           0x004008c4      bf7f0a4000     mov edi, 0x400a7f
│           0x004008c9      b800000000     mov eax, 0
│           0x004008ce      e82dfdffff     call sym.imp.printf         ; int printf(const char *format)
│           0x004008d3      488d45e0       lea rax, qword [var_20h]
│           0x004008d7      4889c6         mov rsi, rax
│           0x004008da      bf820a4000     mov edi, str.20s            ; 0x400a82 ; "%20s"
│           0x004008df      b800000000     mov eax, 0
│           0x004008e4      e887fdffff     call sym.imp.__isoc99_scanf ; int scanf(const char *format)
│           0x004008e9      488d45e0       lea rax, qword [var_20h]
│           0x004008ed      4889c6         mov rsi, rax
│           0x004008f0      bf870a4000     mov edi, str.s              ; 0x400a87 ; "[%s]\n"
│           0x004008f5      b800000000     mov eax, 0
│           0x004008fa      e801fdffff     call sym.imp.printf         ; int printf(const char *format)
│           0x004008ff      488b55f8       mov rdx, qword [var_8h]
│           0x00400903      488d45e0       lea rax, qword [var_20h]
│           0x00400907      4889d6         mov rsi, rdx
│           0x0040090a      4889c7         mov rdi, rax
│           0x0040090d      e81efdffff     call sym.imp.strcmp         ; int strcmp(const char *s1, const char *s2)                                                                                                                 
│           0x00400912      8945f4         mov dword [var_ch], eax
│           0x00400915      837df400       cmp dword [var_ch], 0
│       ┌─< 0x00400919      740a           je 0x400925
│       │   0x0040091b      bf01000000     mov edi, 1
│       │   0x00400920      e85bfdffff     call sym.imp.exit           ; void exit(int status)
│       └─> 0x00400925      bf8d0a4000     mov edi, 0x400a8d
│           0x0040092a      b800000000     mov eax, 0
│           0x0040092f      e8ccfcffff     call sym.imp.printf         ; int printf(const char *format)
│           0x00400934      488d45e0       lea rax, qword [var_20h]
│           0x00400938      4889c6         mov rsi, rax
│           0x0040093b      bf820a4000     mov edi, str.20s            ; 0x400a82 ; "%20s"
│           0x00400940      b800000000     mov eax, 0
│           0x00400945      e826fdffff     call sym.imp.__isoc99_scanf ; int scanf(const char *format)
│           0x0040094a      bf14000000     mov edi, 0x14               ; 20
│           0x0040094f      e839feffff     call fcn.0040078d
│           0x00400954      4889c2         mov rdx, rax
│           0x00400957      488d45e0       lea rax, qword [var_20h]
│           0x0040095b      4889d6         mov rsi, rdx
│           0x0040095e      4889c7         mov rdi, rax
│           0x00400961      e8cafcffff     call sym.imp.strcmp         ; int strcmp(const char *s1, const char *s2)                                                                                                                 
│           0x00400966      85c0           test eax, eax
│       ┌─< 0x00400968      750c           jne 0x400976
│       │   0x0040096a      488d45c0       lea rax, qword [var_40h]
│       │   0x0040096e      4889c7         mov rdi, rax
│       │   0x00400971      e802000000     call fcn.00400978
│       └─> 0x00400976      c9             leave
└           0x00400977      c3             ret

Methode 1 :

r2 -N -w ./impossible_password.bin

aaa

s 0x00400966; wa jmp 0x0040096a; pd 1 #saut jne (strcmp)

./impossible_password.bin

quit

SuperSeKretKey

aaa

H****************}

Methode 2 :

r2 -N -w ./impossible_password.bin

aaa

wx 9090

wa nop

quit

./impossible_password.bin

SuperSeKretKey

aaa
 
H****************}