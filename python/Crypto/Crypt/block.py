from Crypt.utils import *
from Crypto.Cipher import AES
import copy

__all__ = ['pad', 'unpad', 
           'check_padding',
           'encrypt_cbc', 'decrypt_cbc',
           'encrypt_ecb', 'decrypt_ecb']

def encrypt_ecb(plaintext, key):
    '''encrypt plaintext usin AES in ECB mode'''
    cipher = AES.new(key)
    return bytearray( cipher.encrypt(plaintext))

def decrypt_ecb(ciphertext, key):
    '''decrypt ciphertext bytearray use AES in ECB mode'''
    cipher = AES.new(key)
    return cipher.decrypt(bytes(ciphertext))

def encrypt_cbc(plaintext, iv, key):
    '''encrypt plaintext using AES in CBC mode

    msg = b'plaintext message'
    iv = b'this is 16 bytes'
    key = b'yellow submarine'

    encrypt_cbc(msg, iv, key)    
    '''
    blocksize = 16              # AES standand
    cipher = AES.new(key.decode('ascii'))
    p = bytearray( pad( plaintext))
    c = bytearray()
    prev = bytearray(iv)

    for i in range(0, len(p), blocksize):
        b = p[i:i+blocksize]
        xor = same_length_xor(b, prev)
#        e = encrypt_ecb(bytes(xor), key)
        e =  cipher.encrypt(bytes(xor))
        c.extend(e)
        prev = e

    return c

def decrypt_cbc(ciphertext, iv, key):
    '''decrypt bytearary ciphertext using AES in CBC mode'''
    blocksize = 16              # AES standand
    cipher = AES.new(key)
    p = bytearray()
    prev = bytearray(iv)        # previous block

    for i in range(0, len(ciphertext), blocksize):
        b = ciphertext[i:i+blocksize]
        d = cipher.decrypt(bytes(b))
        p.extend( same_length_xor( d, prev ))
        prev = b

    return p

def pad(string, blocksize=16):
    '''pad string to comply with PKCS#7'''
    nbytes = 0
    s = string[:]               # copy
    if len(s) % blocksize == 0:
        nbytes = blocksize
    else:
        nbytes = blocksize - (len(s) % blocksize)

    pad = nbytes * chr(nbytes)
    return s + pad.encode('ascii')

def unpad(padded, blocksize=16):
     '''remove PKCS#7 padding'''
     check_padding(padded, blocksize)
     s = padded[:]
     pad = s[-1]
     return s[0:len(s)-pad]

def check_padding(padded, blocksize=16):
    '''check padding conforms to PKCS#7'''
    b = padded[:]
    pad = b[-1]
    if pad > blocksize:
        raise RuntimeError("padding byte error, are you sure this block is padded?")
    if len(padded) % blocksize != 0:
            raise RuntimeError("padding byte error, are you sure this block is padded?")
    for n in range(pad):
        index = 0 - n - 1
        if b[index] != pad:
            raise RuntimeError("ill formed padding")

