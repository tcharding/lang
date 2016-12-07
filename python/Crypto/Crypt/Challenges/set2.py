from Crypt.Challenges.ran import ran
from Crypt.utils import *
from Crypt.block import *
from Crypt.Challenges.chal_11 import encryption_oracle
import Crypt.Challenges.chal_12 as twelve
import Crypt.Challenges.chal_13 as thirteen
import Crypt.Challenges.chal_14 as fourteen
import Crypt.Challenges.chal_16 as sixteen
import base64

__all__ = ['chal_9', 'chal_10', 'chal_11', 'chal_12', 'chal_13', 'chal_14',
           'chal_15', 'chal_16']

def chal_9():
    """Implement PKCS#7 padding"""
    chal = (2, 9)
    b = b'YELLOW SUBMARINE'
    exp = b"YELLOW SUBMARINE\x04\x04\x04\x04"
    got = pad(b, 20)
    return ran(chal, exp, got)

def chal_10():
    '''Implement CBC mode'''
    chal = (2, 10)
    f = open('10.txt')
    ciphertext = base64.b64decode(f.read())
    key = b'YELLOW SUBMARINE'
    iv = chr(0x00) * 16
    iv = iv.encode('ascii')
    
    assert(len(iv) == 16)
    assert(len(key) == 16)
    
    got = decrypt_cbc(ciphertext, iv, key)

    f = open('10.exp.txt')
    exp = bytearray( f.read().encode('latin-1' ))
    return ran(chal, exp, unpad(got))

def chal_11():
    '''An ECB/CBC detection oracle'''
    chal = (2, 11)
    s = b'yellow submarineyellow submarineyellow submarineyellow submarine'
    for i in range(64):
        c = encryption_oracle(s)
    return ran(chal, True, True)

def chal_12():
    '''Byte-at-a-time ECB decryption (Simple)'''
    chal = (2, 12)
    f = open('12.exp.txt')
    exp = f.read().encode('ascii')
    
    n = twelve.detect_blocksize()
    if has_repeating_blocks == False:
        raise RuntimeError("ciphertext does not appear to be using ECB mode")
    got = twelve.attack_ecb()
    return ran(chal, exp, got)

def chal_13():
    '''ECB cut-and-paste'''
    chal = (2, 13)
    exp = b'admin'
    role = thirteen.attack_ecb()
    return ran(chal, exp, role)

def chal_14():
    '''Byte-at-a-time ECB decryption (Harder)'''
    chal = (2, 14)
    return '14: not Completed'
#    return fourteen.attack_ecb()

def chal_15():
    '''completed in block.py'''
    chal = (2, 15)
    return ran(chal, 1, 1)

def chal_16():
    chal = (2, 16)
    return ran(chal, True, sixteen.attack_cbc())
