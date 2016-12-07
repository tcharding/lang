from Crypt.block import (random_key, encrypt_ecb, decrypt_ecb, pad, unpad)
from Crypt.utils import (parse_kv, profile_for, encode_kv)
#
# ECB cut-and-paste
#
key = random_key()

def attack_ecb():
    s = b'abcd@mail.com'           # 13 bytes
    c1 = encrypt(s)                # we want blocks 1 and 2 from this

    s = b'ten@ab.com'              # 10 bytes (email=ten@ab.com is 16 bytes)
    s += pad(b'admin')
    assert(len(s) == 26)
    c2 = encrypt(s)             # we want block 2 from this

    c = bytearray( c1[0:32])
    c.extend( bytearray( c2[16:32]))
    
    c = bytes( c)
    # attack goes here

    # confirm attack, return role
    d = decrypt(c)
    return d[b'role']

def encrypt(s):
    ''' encode string, pad it, encrypt it in ECB mode'''
    return encrypt_ecb( pad( encode_kv( profile_for( s))), key)

def decrypt(c):
    ''' decrypt ECB mode, unpad it, parse to kv string'''
    return parse_kv( unpad( decrypt_ecb( c, key)))
