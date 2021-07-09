CHAL baby re :

liste commande :

1ere methode :

file Baby_RE.zip 
Baby_RE.zip: Zip archive data, at least v2.0 to extract

Archive:  Baby_RE.zip
   skipping: baby                    unsupported compression method 99

# utiliser 7z avec e pr extract et -p pr password

7z x -phackthebox Baby_RE.zip

chmod +x baby

strings baby # recup la key et lancer baby

2eme methode utiliser radare2 plus relou:

liste commande et affichage resultat :

chmod +x baby

r2 -N -w baby

[0x00001155]> aaa
[x] Analyze all flags starting with sym. and entry0 (aa)
[x] Analyze function calls (aac)
[x] Analyze len bytes of instructions for references (aar)
[x] Check for objc references
[x] Check for vtables
[x] Type matching analysis for all functions (aaft)
[x] Propagate noreturn information
[x] Use -AA or aaaa to perform additional experimental analysis.
[0x00001155]> s 0x0000119f; wa jmp 0x000011a3; pd 1
Written 2 byte(s) (jmp 0x000011a3) = wx eb02
|       ,=< 0x0000119f      eb02           jmp 0x11a3
[0x0000119f]> pdf
            ; DATA XREF from entry0 @ 0x108d
/ 152: int main (int argc, char **argv, char **envp);
|           ; var char *s @ rbp-0x40
|           ; var int64_t var_38h @ rbp-0x38
|           ; var int64_t var_30h @ rbp-0x30
|           ; var int64_t var_2ch @ rbp-0x2c
|           ; var char *s1 @ rbp-0x20
|           ; var char *var_8h @ rbp-0x8
|           0x00001155      55             push rbp
|           0x00001156      4889e5         mov rbp, rsp
|           0x00001159      4883ec40       sub rsp, 0x40
|           0x0000115d      488d05a40e00.  lea rax, qword str.Dont_run__strings__on_this_challenge__that_is_not_the_way ; 0x2008 ; "Dont run `strings` on this challenge, that is not the way!!!!"                                  
|           0x00001164      488945f8       mov qword [var_8h], rax
|           0x00001168      488d3dd70e00.  lea rdi, qword str.Insert_key: ; 0x2046 ; "Insert key: " ; const char *s                                                                                                                 
|           0x0000116f      e8bcfeffff     call sym.imp.puts           ; int puts(const char *s)
|           0x00001174      488b15c52e00.  mov rdx, qword [obj.stdin]  ; rdi
|                                                                      ; [0x4040:8]=0 ; FILE *stream              
|           0x0000117b      488d45e0       lea rax, qword [s1]
|           0x0000117f      be14000000     mov esi, 0x14               ; int size
|           0x00001184      4889c7         mov rdi, rax                ; char *s
|           0x00001187      e8b4feffff     call sym.imp.fgets          ; char *fgets(char *s, int size, FILE *stream)                                                                                                               
|           0x0000118c      488d45e0       lea rax, qword [s1]
|           0x00001190      488d35bc0e00.  lea rsi, qword str.abcde122313 ; 0x2053 ; "abcde122313\n" ; const char *s2                                                                                                               
|           0x00001197      4889c7         mov rdi, rax                ; const char *s1
|           0x0000119a      e8b1feffff     call sym.imp.strcmp         ; int strcmp(const char *s1, const char *s2)                                                                                                                 
|       ,=< 0x0000119f      eb02           jmp 0x11a3
|      ,==< 0x000011a1      7537           jne 0x11da
|      |`-> 0x000011a3      48b84854427b.  movabs rax, 0x594234427b425448 ; 'HTB{B4BY'
|      |    0x000011ad      48ba5f523356.  movabs rdx, 0x3448545f5633525f
|      |    0x000011b7      488945c0       mov qword [s], rax
|      |    0x000011bb      488955c8       mov qword [var_38h], rdx
|      |    0x000011bf      c745d054535f.  mov dword [var_30h], 0x455f5354 ; 'TS_E'
|      |    0x000011c6      66c745d45a7d   mov word [var_2ch], 0x7d5a  ; 'Z}'
|      |    0x000011cc      488d45c0       lea rax, qword [s]
|      |    0x000011d0      4889c7         mov rdi, rax                ; const char *s
|      |    0x000011d3      e858feffff     call sym.imp.puts           ; int puts(const char *s)
|      |,=< 0x000011d8      eb0c           jmp 0x11e6
|      ||   ; CODE XREF from main @ 0x11a1
|      `--> 0x000011da      488d3d7f0e00.  lea rdi, qword str.Try_again_later. ; 0x2060 ; "Try again later." ; const char *s                                                                                                        
|       |   0x000011e1      e84afeffff     call sym.imp.puts           ; int puts(const char *s)
|       |   ; CODE XREF from main @ 0x11d8
|       `-> 0x000011e6      b800000000     mov eax, 0
|           0x000011eb      c9             leave
\           0x000011ec      c3             ret
[0x0000119f]> quit
                                                                                                                  
┌──(kali㉿kali)-[~/CTF/HTB/REVERSING/baby_re]
└─$ ./baby 
Insert key: 
s
H**************** # strcmp break


