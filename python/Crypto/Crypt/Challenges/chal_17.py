from Crypt.Challenges.ran import ran
from Crypt.utils import *
from Crypt.block import *
from random import randint
import base64
import sys

key = random_key()

def attack_cbc():
    (c, iv) = encrypt_fn()
    # attack first block i.e modify the IV
    bs = 16
    p = b''

    for i in range(0, bs):
        k = bs - i - 1         # index of mod byte
        front = iv[0:k]
        byte = iv[k]
        pad = i+1
        back = craft_back(iv, p)

        for j in range(32, 127):
            crafted_iv = bytearray(front)
            crafted_iv.append(byte ^ pad ^ j)
            crafted_iv.extend(back)

            if padding_oracle(c[0:16], byte_to_ascii(crafted_iv)) == True:
                print('got char *%s*' % chr(j))
                p += chr(j).encode('ascii')
                break
        else:
            raise RuntimeError("failed to find character")
    return p

def craft_back(block, p):
    back = bytearray()
    pad = len(p) + 1
    for n in range(0, len(p)):
        i = 0 - n - 1           
        back.append(pad ^ p[i] ^ block[i])

    return back

def test_craft_back():
    block = b'yellow submarine'
    p = b'ine'

def encrypt_fn():
    iv = random_key()
    f = open('17.txt')
    lines = f.readlines()
    i = randint(0, len(lines)-1)
    p = base64.b64decode(lines[i])
    c = encrypt_cbc(p, iv, key)
    return (c, iv)

def padding_oracle(c, iv):
    '''decrypt and check padding'''
    p = decrypt_cbc(c, iv, key)
    try:
        check_padding(p)
    except RuntimeError:
        return False
    return True


