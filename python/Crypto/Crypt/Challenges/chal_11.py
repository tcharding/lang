from Crypt.Challenges.ran import ran
from Crypt.utils import *
from Crypt.block import *
from random import (seed, uniform)

ECB = 1
CBC = 2

def detect_mode(c):
    '''Attempt to detect encryption mode (CBC or ECB2'''
    if has_repeating_blocks(c):
        return ECB
    else:
        return CBC


def encryption_oracle(string):
    key = random_key()
    seed()
    nbytes = int(uniform(5, 11))
    data = random_key(nbytes) + string + random_key(nbytes)

    mode = int(uniform(1, 3))    # 1 or 2
    if mode == 1:
        c = encrypt_ecb(pad(data), key)
    elif mode == 2:
        iv = random_key()
        c = encrypt_cbc(data, iv, key)
    else:
        raise RuntimeError("programmer error")

    # for testing
    got = detect_mode(c)
    if got != mode:
        print ("Fail: exp: %s got: %s" % (mode, got))
    return c

