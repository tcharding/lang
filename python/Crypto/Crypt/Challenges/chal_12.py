from Crypt.Challenges.ran import ran
from Crypt.utils import *
from Crypt.block import *
from random import (seed, uniform)

# from question
key = random_key()

def attack_ecb():
    '''Attack ECB mode encryption oracle'''
    bs = 16                           # AES block size
    r = len(encryption_oracle(b""))     # number of bytes to recover
#    r = 64
    p = b""
    
    for n in range(r):        
        d = build_dictionary(craft_attack_string(p, r))
        ostring = 'A' * (r - 1 - n)
        c = encryption_oracle(ostring.encode('ascii'))
        oracle = c[r-bs:r]      # block from oracle
        
        for char, block in d.items():
            if oracle == block:
                p += char.encode('ascii')
                break
        else:
            break

    return p

def craft_attack_string(p, r):
    '''make string len r-1 where r is multiple of blocksize'''
    bs = 16
    s = 'A' * (bs - 1 - len(p)) 
    return s.encode('ascii') + p


def build_dictionary(attack_string):
    '''build dictionary: d[char] = bytearray ciphertext block

    where char is ascii character in set: printable and PKCS#7 padding'''
    bs = 16
    ln = len(attack_string)
    base = attack_string[ln-bs+1:ln] # last 15 characters
    assert(len(base) == bs-1)

    chars = [n for n in range(32, 127)]
    chars.append(10)            # we need new line also
    
    d = {}
    for n in chars:
        char = chr(n)
        s = base + char.encode('ascii')
        ciphertext = encryption_oracle(s)
        d[char] = ciphertext[0:bs]

    return d

def detect_blocksize():
    '''Detect blocksize used by encryption oracle'''
    c = encryption_oracle(b'')
    size = len(c)
    i = 0
    while True:
        s = 'A' * i
        c = encryption_oracle(s.encode('ascii'))
        if len(c) > size:
            return len(c) - size
        i += 1        
    
def encryption_oracle(string):
    s = b'''
    Um9sbGluJyBpbiBteSA1LjAKV2l0aCBteSByYWctdG9wIGRvd24gc28gbXkg
    aGFpciBjYW4gYmxvdwpUaGUgZ2lybGllcyBvbiBzdGFuZGJ5IHdhdmluZyBq
    dXN0IHRvIHNheSBoaQpEaWQgeW91IHN0b3A/IE5vLCBJIGp1c3QgZHJvdmUg
    YnkK'''
    unknown =  base64_to_byte(s).decode('ascii')
    msg = string + unknown.encode('ascii')
    return encrypt_ecb( pad( msg), key)

