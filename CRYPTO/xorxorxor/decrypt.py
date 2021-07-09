#!/usr/bin/python3
import os
import itertools

shifr  = bytearray.fromhex('134af6e1297bc4a96f6a87fe046684e8047084ee046d84c5282dd7ef292dc9')

start =  bytearray.fromhex('134af6e1')
text = 'HTB{'.encode()

key = b''
output = b''

for i in range(len(start)):
	key += bytes([text[i] ^ start[i]])


output2 = b''

for i in range(len(shifr)):
    output2 += bytes([shifr[i] ^ key[i % len(key)]])
    output_dec = output2.decode(errors='ignore')

print('Flag: '+ output_dec)
#print('\n')