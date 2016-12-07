from Crypt.base import *

# from question
inp = '49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d'
exp = 'SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t'

bits = decode_hex(inp)
b64 = encode_base64(bits)

run('1', '1', exp, b64)
