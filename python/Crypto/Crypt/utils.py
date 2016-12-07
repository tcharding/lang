import base64
import binascii
import random

__all__ = ['byte_to_hex', 'hex_to_byte',
           'byte_to_base64', 'base64_to_byte',
           'byte_to_ascii',
           'repeating_xor', 'has_repeating_blocks',
           'pad_octet', 'same_length_xor',
           'random_key',
           'parse_kv', 'profile_for', 'encode_kv']

def random_key(len=16):
    key = ""
    random.seed()
    for i in range(len):
        key += chr(int(random.uniform(32, 126)))
    return key.encode('ascii')
    
def pad_octet(bitstring):
    """pad bitstring to 8 bits"""
    while(len(bitstring) < 8):
        bitstring = "0" + bitstring
    return bitstring

def hex_to_byte(s):
    """Convert hex string to byte array"""
    return bytearray.fromhex(s.decode('latin-1'))

def byte_to_hex(b):
    """Convert bytearray to hex string"""
    retval = b""
    for byte in b:
        h = hex(byte).split('x')[1].encode('ascii')
        if len(h) == 1:         # we need 2 digit hex strings
            h = b"0" + h
        retval += h
    return retval

def byte_to_ascii(b):
    '''convert bytearray to ascii bytestring'''
    return b.decode('ascii').encode('ascii')

def base64_to_byte(s):    
    """Encode bytearray as base 64 string"""
    return bytearray( base64.b64decode(s.decode('ascii')))


def byte_to_base64(b):
    """Convert bytearray to base 64 string"""
    return base64.b64encode(b)
    
# def ascii_to_byte(s):
#     """Convert string to byte array"""
#     return bytearray(s)

# def byte_to_ascii(b):
#     """Convert bytearray to string"""
#     return b.decode('ascii')

# def string_to_byte(string):
#     """Convert string to byte array"""
#     return bytearray(string.encode('ascii'))

# def byte_to_string(b):
#     """Convert bytearray to string"""
#     return b.decode('ascii')

def repeating_xor(b, k):
    """repeating xor bytearray b against bytearray k"""
    retval = bytearray()

    for i in range(len(b)):
        ki = i % len(k)
        retval.append( b[i] ^ k[ki] )
    return retval

def has_repeating_blocks(b, blocksize=16):
    """Big O: O n squared"""
    for i in range(0, len(b), blocksize):
        repeats = 0
        block = b[i:i+blocksize]
        for j in range(0, len(b), blocksize):
            compare = b[j:j+blocksize]
            if block == compare:
                repeats += 1
        if repeats > 1:         # 1 for block compared with itself
            return True
    return False

def same_length_xor(ba, bb):
    """xor two same length bytearrays"""
    xor = [a ^ b for a,b in zip(ba, bb)]
    return bytearray(xor)

def parse_kv(kvstring):
    '''parses key=value string into dictionary
    '''
    d = {}
    for kv in kvstring.split(b'&'):
        key, value = kv.split(b'=')
        d[key] = value
    return d


def profile_for(address):
    ''' create dictionary for address 

    >>> profile_for('foo@bar.com')
    {'email': 'foo@bar.com', 'uid': 10, 'role': 'user'}
    >>>
    '''
    # prevent cracking email address
    address = address
    address = address.split(b'&')[0]
        
    d = {};
    d[b'email'] = address
    d[b'uid'] = b'10'
    d[b'role'] = b'user'
    return d

def encode_kv(d):
    '''encode dictionary as key value string

    >>> d = profile_for('me@mail.com')
    >>> encode_kv(d)
    'email=me@tobin.com&uid=10&role=user'
    >>> 
    '''
    s = b'email=' + d[b'email'] + b'&uid=' + d[b'uid'] + b'&role=' + d[b'role']
    return s

if __name__ == '__main__':
    # test myself
    import doctest
    doctest.testmod()
