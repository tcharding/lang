from Crypt.utils import (repeating_xor, pad_octet)
import operator

def crack_key(b, keysize):
    """(b has been 'encrypted' using repeating xor)"""
    
    trans_blocks = transpose(b, keysize)
    key = ""
    for t in trans_blocks:
        brute_force = bruteforce_scx(t)
        rated = rate(brute_force)
        key += top_rated_key(rated)
        
    return key

def keysize_hamming_method(b):
    """determine keys size using hamming method
    (b has been 'encrypted' using repeating xor)"""
    hmlist = []
#    print(len(b))
    for keysize in range(2, 40):
        blocka = b[0:keysize]
        blockb = b[keysize:keysize*2]
        hm = hamming(blocka, blockb)
        normalized = hm / keysize
        hmlist.append((keysize, normalized))
    hmsorted = sorted(hmlist, key=lambda hm: hm[1]) # sort by hamming distance
    for keysize, hm in hmsorted:
        print("%s: %s" % (keysize, hm))

def transpose(b, num):
    """traspose b into num blocks"""
    blocks = []
    for i in range(num):
        blocks.append(bytearray())

    for i in range(len(b)):
        bi = i % num
        blocks[bi].extend(b[i:i+1])

    assert(len(blocks) == num)
    for i in range(num):
        assert(len(blocks[i]) != 0)
    return blocks
        
def keysize_friedman_method(b, maximum=40):
    """determine keys size using friedman method
    (b has been 'encrypted' using repeating xor)
    
    https://en.wikipedia.org/wiki/Index_of_coincidence"""
    ic_of_keylen = {}
    C = 26                      # Normalizing co-efficient

    for nchars in range(2, maximum):
        trans_blocks = transpose(b, nchars)
        (inctot, total) = (0, 0)
        for t in trans_blocks:
            (n, N) = (0, 0)     # see wiki link
            N = len(t)
            for i in range(0, N-1):
                n = 0
                byte = t[i:i+1]
                for j in range(0, N-1):
                    compare = t[j:j+1]
                    if compare == byte:
                        n += 1
            inctot += (n * (n - 1)) / (N * (N - 1))
            ic = inctot * C
            total += ic
        
        ic_of_keylen[nchars] = total / nchars

    sort = sorted(ic_of_keylen.items(), key=operator.itemgetter(1))
    return sort[-1][0]
        
def hamming(b, c):
    """Calculate hamming distance between two same length strings"""
    hamming = 0
    for bs, bt in zip(b, c):
        octets = pad_octet(bin(bs).split("b")[1])
        octett = pad_octet(bin(bt).split("b")[1])

        for bits, bitt in zip(octets, octett):
            if bits != bitt:
                hamming += 1
    return hamming

def bruteforce_scx(b):
    """brute force single char xor b against all printable characters
    return dictionary {char, msg}"""
    bf = {}
    for n in range(32, 126):
        xor = bytearray()
        for m in range(0, len(b)):
            xor.append(b[m] ^ n)

        bf[chr(n)] = xor
    return bf

def rate(d):
    """Rate messages
    return list of (char, msg, rating) tuples"""
    rated = []
    for key, b in d.items():
        rating = rate_ba(b)
        rated.append((key, b, rating))

    return rated

def top_rated(rated):
    """return top rated message from rated as string"""
    top = 0;
    # first we need the top rating
    for key, msg, rating in rated:
        if rating > top:
            top = rating

    # now get top rated messages
    top_rated = []
    for key, msg, rating in rated:
        if rating == top:
            top_rated.append(msg)

    if len(top_rated) == 1:
        return top_rated.pop()
    else:
        return bytearray(b"Cannot get top rated")
#        raise RuntimeError("More than one message with top rating")
def top_rated_key(rated):
    """return key of top rated message from rated"""
    top = 0;
    # first we need the top rating
    for key, msg, rating in rated:
        if rating > top:
            top = rating

    # now get top rated messages
    top_rated = []
    for key, msg, rating in rated:
        if rating == top:
            top_rated.append(key)

    if len(top_rated) == 1:
        return top_rated.pop()
    else:
        return "*"
    

def rate_ba(b):
    """rate message on english language metrics"""
    score = 0
    score += rate_printable( b )
    score += rate_punctuation( b )
    score += rate_most_frequent( b )
    score += rate_least_frequent( b )
    score += rate_common( b )
    return score

def count(b, l):
    count = 0
    total = 0
    for b in b:
        if chr(b) in l:
            count += 1
        total += 1
    return (count, total)

def count_unprintable(b):
    printable = []
    for n in range(32, 126):
        printable.append(chr(n))
    (printable, total) = count(b, printable)
    return total - printable

def rate_printable(b):
    retval = 0
    unprintable = count_unprintable(b)
    if unprintable == 0:
        return 100
    elif unprintable == 1:
        return 50
    elif unprintable == 2:
        return -50

    return -100
        

def rate_common(b):    
    common = ['\'', '\"', ' ', '.', ',', '?', '!', '(', ')', '\n']
    for n in range(65, 91):     # upper case letters
        common.append(chr(n))
        
    for n in range(97, 123):     # lower case letters
        common.append(chr(n))
        
    for n in range(48, 58):     # digits
        common.append(chr(n))
        
    (cnt, total) = count(b, common)

    if total == 0:
        return 0
    
    p = cnt / total
    retval = 0
        
    if p > 0.95:
        retval = 100
    elif p > 0.90:
        retval = 75
    elif p > 0.85:
        retval = 50
    elif p > 0.80:
        retval = 25
    elif p > 0.75:
        retval = 0
    elif p > 0.60:
        retval = -25
    elif p > 0.45:
        retval = -50
    elif p > 0.30:
        retval = -75                                    
    else:
        retval -100;
    return retval

def rate_punctuation(b):
    punc = []
    for n in range(33, 65):
        punc.append(chr(n))
    
    for n in range(91, 97):
        punc.append(chr(n))
    
    for n in range(123, 127):
        punc.append(chr(n))

    (cnt, total) = count(b, punc)
    if total == 0:
        return 0
    
    p = cnt / total
    retval = 0
    if p < 0.10:
        retval = 50
    elif p < 0.20:
        retval = 25
    elif p < 0.30:
        retval = 0
    elif p < 0.50:
         retval = 25
    else:
        retval = -50;

    return retval

def rate_most_frequent(b):
    most = ['e', 't', 'a', 'o', 'i']
    (cnt, total) = count(b, most)
    if total == 0:
        return 0

    p = cnt / total
    if is_between(p, 0.35, 0.40):
        return 50
    elif is_between(p, 0.30, 0.45):
        return 25
    elif is_between(p, 0.25, 0.50):
        return 0
    elif is_between(p, 0.15, 0.60):
        return -25

    return -50

def is_between(n, minimum, maximum):
    """return True if n lies between minimum and maximum"""
    if n >= minimum:
        if n < maximum:
            return True
    return False

def rate_least_frequent(b):
    if count_unprintable(b) > 3:
        return 0                # don't bother to rate if contains rubish
    
    least = ['z', 'q', 'x', 'j', 'k']
    (cnt, total) = count(b, least)
    if total == 0:
        return 0

    p = cnt / total
    if p < 0.02:
        return 50
    elif p < 0.0:
        return
    elif p < 0.05:
        return 25
    elif p < 0.10:
        return 0
    elif p < 0.20:
        return -25
    return -50
