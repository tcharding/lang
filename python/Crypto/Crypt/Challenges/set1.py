from Crypt.Challenges.ran import ran
from Crypt.utils import *
from Crypt.block import *
from Crypt.vigenere import (bruteforce_scx, rate, top_rated, repeating_xor,
                            keysize_friedman_method, crack_key)
from Crypto.Cipher import AES
import base64

#__all__ = ['chal_1', 'chal_', 'chal_', 'chal_', 'chal_', 'chal_', 'chal_']
__all__ = ['chal_1', 'chal_2', 'chal_3', 'chal_4', 'chal_5', 'chal_6', 'chal_7', 'chal_8']

def chal_1():
    """Convert hex to base64"""
    chal = (1, 1)
    s = b'49276d206b696c6c696e6720796f757220627261696e206c'
    s += b'696b65206120706f69736f6e6f7573206d757368726f6f6d'
    exp = b'SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t'
    b = hex_to_byte(s)
    got = byte_to_base64(b)

    return ran(chal, exp, got)

def chal_2():
    """Fixed XOR"""
    chal = (1, 2)
    s = b'1c0111001f010100061a024b53535009181c'
    t = b'686974207468652062756c6c277320657965' 
    exp = b'746865206b696420646f6e277420706c6179'

    b = same_length_xor(hex_to_byte(s), hex_to_byte(t))
    got =  byte_to_hex(b)
    return ran(chal, exp, got)
    
def chal_3():
    """Single-byte XOR cipher"""
    chal = (1, 3)
    s = b'1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736'
    exp = b'Cooking MC\'s like a pound of bacon'

    brute_force = bruteforce_scx(hex_to_byte(s))
    rated = rate(brute_force)
    got = (top_rated(rated))
    return ran(chal, exp, got)

def chal_4():
    """Detect single-character XOR"""
    chal = (1, 4)
    filename = '4.txt'
    exp = b'Now that the party is jumping\n'

    rated = []
    for line in open( filename ):
        b = hex_to_byte( line.strip("\n" ))
        rated.extend( rate( bruteforce_scx( b )))
    got = top_rated( rated )
    return ran(chal, exp, got)

def chal_5():
    """Implement repeating-key XOR"""
    chal = (1, 5)
    key = b'ICE'
    s = b'Burning \'em, if you ain\'t quick and nimble\n'
    s += b'I go crazy when I hear a cymbal'
    exp = b'0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a'
    exp += b'26226324272765272a282b2f20430a652e2c652a3124333a653e2b202'
    exp += b'7630c692b20283165286326302e27282f'

    got = byte_to_hex(repeating_xor( bytearray(s), bytearray(key)))
    return ran(chal, exp, got)

def chal_6():
    chal = (1, 6)
    f = open('6.exp.txt')
    exp = f.read().strip("\n")

    f = open('6.txt')
    b = base64_to_byte( f.read().encode('ascii') )
    # keysize = keysize_friedman_method(b)
    keysize = 29                # from above
    # key = crack_key(b, keysize)
    key = b'Terminator X: Bring the noise' # from above
    
    got =  repeating_xor(b, key).decode('ascii')
    return ran(chal, exp, got)

def chal_7():
    """AES in ECB mode"""
    chal = (1, 7)
    key = b'YELLOW SUBMARINE'
    f = open('7.exp.txt')
    exp = f.read()
    exp = exp[0:len(exp)-1]
    exp = exp.encode('ascii')
    

    f = open('7.txt')
    c = f.read()
    got = decrypt_ecb(base64.b64decode(c), key)
    return ran(chal, exp, got)

def chal_8():
    """Detect AES in ECB mode"""
    chal = (1, 8)
    got = (False, "")
    f = open('8.txt')
    for line in f:
        b = hex_to_byte(line.strip("\n").encode('ascii'))
        if has_repeating_blocks(b):
            got = (True, line)
    
    return ran(chal, True, got[0])
