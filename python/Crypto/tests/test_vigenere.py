from random import randint
from nose.tools import *
from Crypt.vigenere import (bruteforce_scx, rate, top_rated, hamming)

def test_bruteforce_scx():
    ba = bytearray(b'test string')
    d = bruteforce_scx(ba)
    assert_equal(len(d), 94)
    for n in range(32, 126):
        k = chr(n)
        assert_equal(k in d, True)

def test_top_rated():
    rated = [(chr(33), bytearray(b'test message'), 1000)]

    bad = bytearray(b'low rated')
    c = 34
    for n in range(20):
        rated.append((chr(c + n), bad, randint(0, 100)))

    s = top_rated(rated)
    assert_equal(s, b'test message')

def test_rate():
    b = bytearray (b'this is a test message written in english') # len = 41
    d = {}
    d['!'] = b

    rated = rate(d)
    (key, msg, rating) = rated[0]
    assert_equal(key, '!')
    assert_equal(msg, b)
    assert_equal(rating, 325)
    
    s = top_rated(rated)
    assert_equal(s, b'this is a test message written in english') # len = 41

def test_hamming():
    a = bytearray(b'this is a test')
    b = bytearray(b'wokka wokka!!!')
    ham = hamming(a, b)
    assert_equal(ham, 37)
