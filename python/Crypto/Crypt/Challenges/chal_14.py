from Crypt.Challenges.ran import ran
from Crypt.utils import *
from Crypt.block import *
from random import (seed, uniform, randint)


# from question
key = random_key()

def attack_ecb():
    '''Attack ECB mode encryption oracle'''
    bs = 16                           # AES block size
    r = len(encryption_oracle(""))     # number of bytes to recover
    p = ""

    for n in range(r):
        s = craft_attack_string(p, r)
        d = build_dictionary(s)
        s = craft_oracle_string(n, r)
        s = 32 * 'B' + s
        c = encryption_oracle( s)
        while has_repeating_blocks( c) == 0:
            c = encryption_oracle( s)
            
        oracle = c[r-bs+32:r+32]      # block from oracle
        
        for char, block in d.items():
            if oracle == block:
                p += char
                break
        else:
            break

    return p

def craft_oracle_string(n, r):
    '''make attack string, no identicle blocks'''
    blocksize = 16
    s = ""
    total = r - 1 - n
    (blocks, remainder) = divmod(total, blocksize)
    for n in range(0, blocks*blocksize):
        s += chr(randint(32, 126))

    for n in range(0, remainder):
        s += 'A'

    assert(len(s) == total)
    return s
    
def craft_attack_string(p, r):
    '''make string len r-1 where r is multiple of blocksize'''
    s = ""

    for n in range(0, r-1-len(p)-16):
        s += chr(randint(32, 126))
        
    for n in range(0, 16-1-len(p)):
        s += 'A'
    s += p
    return s


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
        ciphertext = encryption_oracle(base + char)
        d[char] = ciphertext[0:bs]

    return d

def detect_blocksize():
    '''Detect blocksize used by encryption oracle'''
    c = encryption_oracle('')
    size = len(c)
    i = 0
    while True:
        s = 'A' * i
        c = encryption_oracle(s)
        if len(c) > size:
            return len(c) - size
        i += 1        

def encryption_oracle(string):
    s = '''
    Um9sbGluJyBpbiBteSA1LjAKV2l0aCBteSByYWctdG9wIGRvd24gc28gbXkg
    aGFpciBjYW4gYmxvdwpUaGUgZ2lybGllcyBvbiBzdGFuZGJ5IHdhdmluZyBq
    dXN0IHRvIHNheSBoaQpEaWQgeW91IHN0b3A/IE5vLCBJIGp1c3QgZHJvdmUg
    YnkK'''
    unknown = byte_to_string( base64_to_byte (s.strip("\n")))
    rand = random_key( randint(0, 1))
#    print(rand)
    msg = string + unknown
#    msg = rand + string + unknown

    return encrypt_ecb(pad_string(msg), key)

