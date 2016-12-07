from Crypt.Challenges.ran import ran
from Crypt.utils import *
from Crypt.block import *
from random import (seed, uniform)

key = random_key()
iv = random_key()

def attack_cbc():
    attack_string = b';fifteen bytes!!'
    assert(len(attack_string) == 16)
    attack_string += b'admin true' # toggle 'space' to '='

    index = 39
    c = encryption_oracle( attack_string)
    b = c[0:index]
    b.append( c[index] ^ ord(' ') ^ ord('='))
    b.extend(c[index+1:len(c)])
    assert(len(b) == len(c))

    return check_auth( b)

def encryption_oracle(string):
    s = string.decode('ascii')
    pre = "comment1=cooking%20MCs;userdata="
    assert(len(pre) == 32)
    post = ";comment2=%20like%20a%20pound%20of%20bacon"
    p = pre
    for char in s:
        if (char == ';'):
            p += '%3b'
        elif (char == '='):
            p += '%3d'
        else:
            p += char
    p += post
    return encrypt_cbc(p.encode('ascii'), iv, key)
    
def check_auth(c):
    '''decrypt ciphertext from encrypt'''
    p = decrypt_cbc(c, iv, key)
    if p.find(b'admin=true') == -1:
        return False
    return True

