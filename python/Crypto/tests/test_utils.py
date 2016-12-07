from nose.tools import *
from Crypt.utils import * 
import base64
from Crypto.Cipher import AES
import doctest

# run doctest
#nfail, ntests = doctest.testmod(Crypt.utils)

def setup_module():
    # doesn't run
    print("SETUP!")

def teardown():
    # doesn't run
    print("TEAR DOWN!")

def test_hex():
    h = b'7465737420737472696e67'
    base64 = b'dGVzdCBzdHJpbmc='
    s = b'test string'

    b = hex_to_byte(h)
    assert_equal(b, bytearray(s))
    rinsed = byte_to_hex(b)
    assert_equal(rinsed, h)

    
def test_base64():
    base64 = b'dGVzdCBzdHJpbmc='
    s = b'test string'
    b = base64_to_byte(base64)
    assert_equal(b, bytearray(s))
    rinsed = byte_to_base64(b)
    assert_equal(rinsed, base64)

def test_hex_base64():
    # 'test string'
    base64 = b'dGVzdCBzdHJpbmc='
    h = b'7465737420737472696e67'
    bh = hex_to_byte(h)
    bb = base64_to_byte(base64)
    assert_equal(bh, bb)
    r = byte_to_hex(bb)
    assert_equal(r, h)
    r = byte_to_hex(bh)
    assert_equal(r, h)
    r = byte_to_base64(bb)
    assert_equal(r, base64)
    r = byte_to_base64(bh)
    assert_equal(r, base64)

def test_ascii():
    s = b'test string'
    base64 = b'dGVzdCBzdHJpbmc='
    h = b'7465737420737472696e67'

    bh = hex_to_byte(h)
    bb = base64_to_byte(base64)
    b = bytearray(s)
    assert_equal(b, bh)
    assert_equal(b, bb)

#    r = b.decode('ascii').encode('ascii')
    assert_equal(b, s)

# def test_string():
#     s = b'test string'
#     b = string_to_byte(s)
#     r = byte_to_string(b)
#     assert_equal(r, s)

# def test_cipher():
#     """test Crypto.Cipher - not our module"""
#     iv = 'This is an IV456'
#     key = 'This is a key123'
#     msg =  "The answer is no"
#     cipher = AES.new(key, AES.MODE_CBC, iv)

#     ciphertext = cipher.encrypt(msg)
#     print("%s" % ciphertext)
#     p = cipher.decrypt(ciphertext)
#     print("%s" % p)
#     assert_equal(p, msg)

def test_has_repeating_blocks():
    n = b'sntousaotniuasondil,rg.dihqaibsoanhdil;r,gajusko'
    y = b'yellow submarineyellow submarineyellow submarine'
    assert_equal(has_repeating_blocks(y), True)
    assert_equal(has_repeating_blocks(n), False)

def test_random_key():
    key = random_key()
    assert_equal(len(key), 16)
    for i in range(256):
        k2 = random_key()
        assert_not_equal(key, k2)

    key = random_key(64)
    assert_equal(len(key), 64)

def test_parse_kv():
    d = parse_kv(b'foo=bar&baz=qux&zap=zazzle')
    exp = {b'foo': b'bar', b'baz': b'qux', b'zap': b'zazzle'}

    assert_equal(d, exp)


def test_profile_for():
    d = profile_for(b'me@mail.com')
    exp = { b'email': b'me@mail.com', b'role': b'user', b'uid': b'10' }
    assert_equal(d, exp)

def test_encode_kv():
    d = { b'email': b'me@mail.com', b'role': b'user', b'uid': b'10' }
    s = encode_kv(d)
    assert_equal(s, b'email=me@mail.com&uid=10&role=user')

def test_crack_kv():
    crack = b'email=me@mail.com&role=admin'
    s = encode_kv( profile_for(crack))
    assert_raises(ValueError, s.index, b'role=admin')
    

