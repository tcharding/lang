from nose.tools import *
from Crypt.block import *
from Crypt.block import check_padding

def test_cbc_mode():
    msg = b'test plaintext message'
    key = b'yellow submarine'
    iv = b'this is 16 bytes'
    
    c = encrypt_cbc(msg, iv, key)
    p = decrypt_cbc(c, iv, key)
    assert_equal(p, pad
                 (msg))

def test_pad():
    b = bytearray(b'test')
    padded = pad(b)
    assert_equal(len(padded), 16)

    b = bytearray(b'test')
    padded = pad(b, 20)
    assert_equal(len(padded), 20)

    b = bytearray(b'test')
    padded = pad(b, 2)
    assert_equal(len(padded), 6)

    b = bytearray(b'yellow submarine')
    padded = pad(b)
    assert_equal(len(padded), 32)

def test_unpad():
    b = bytearray(b'test test test')
    padded = pad(b)
    assert_equal(len(b), 14)
    assert_equal(len(padded), 16)
    r = unpad(padded)
    assert_equal(len(r), len(b))

    b = bytearray(b'yellow submarine')
    r = unpad(pad(b))
    assert_equal(len(r), len(b))

def test_check_padding():
    correct = b"ICE ICE BABY\x04\x04\x04\x04"
    check_padding( correct)
    correct = b"ICE ICE BABY AB\x01"
    check_padding( correct)
    correct = b"ICE ICE BABY A\x02\x02"
    check_padding( correct)
    
    incorrect = b"ICE ICE BABY A\x01"
    assert_raises( RuntimeError, check_padding, incorrect)
    incorrect = b"ICE ICE BABY\x05\x05\x05\x05"
    assert_raises( RuntimeError, check_padding, incorrect)
    incorrect = b"ICE ICE BABY\x01\x02\x03\x04"
    assert_raises( RuntimeError, check_padding, incorrect)
