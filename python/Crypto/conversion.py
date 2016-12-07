from Crypt.base import *
import base64


bs = b'test string'
s = 'test string'
num = 0x7465737420737472696E67
hs = '7465737420737472696E67'
#h = '0x74, 0x65, 0x73, 0x74, 0x20, 0x73, 0x74, 0x72, 0x69, 0x6E, 0x67'
b64 = 'dGVzdCBzdHJpbmc='

h = encode_hex(hs)
print("h:%s" % h)

ba = bytearray(b'test string')
bs = ba.decode('ascii')
#b = bs.encode('base64')
print("ba: %s" % ba)
print("b: %s" % bs)

#num = 0x7465737420737472696e67
#print("s:%s" % str(num))

#b64 = 'SSyd'
#s = base64.b64decode(b64)
t#xprint("b64: %s" % s)

print("bs: %s \ns: %s \nhs: %s \nh: : %s \nb64: %s \n" % (bs, s, hs, h, b64))
print("hex: %s" % int(hs, 16))
#print("b64: %s" % int(b64, 64))
ba = bytearray.fromhex(hs)
bah = ba.decode('ascii')
print("bah: %s" % bah)


# hex to ascii
ba = bytearray.fromhex(hs)
asci = ba.decode('ascii')
print("asci: %s" % asci)

# ascii to hex
ba = bytearray(b'test string')
hs = ba.hex()
print('hex: %s' % hs)

# base 64
b64 = b'dGVzdCBzdHJpbmc='
bs = base64.b64decode(b64)
print("bs: %s" % bs)

# base 64 to hex
b64 = b'dGVzdCBzdHJpbmc='
bs = base64.b64decode(b64)
ba = bytearray(bs)
asci = ba.decode('ascii')
print("asci: %s" % asci)

