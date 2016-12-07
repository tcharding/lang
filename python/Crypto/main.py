from Crypt.Challenges.set1 import *
from Crypt.Challenges.set2 import *
from Crypt.Challenges.set3 import *
from sys import argv
import optparse

p = optparse.OptionParser()

p.add_option("-a", action="store_true", dest="aflag")
p.add_option("--all", action="store_true", dest="aflag")
p.add_option("-q", action="store_true", dest="qflag")
p.add_option("--quick", action="store_true", dest="qflag")
p.add_option("-t", action="store_true", dest="rflag")
p.add_option("--regression-test", action="store_true", dest="rflag")

p.set_defaults(aflag=False)
p.set_defaults(qflag=False)
p.set_defaults(rflag=False)

opts, args = p.parse_args()
a = opts.aflag
q = opts.qflag
r = opts.rflag

def usage():
    print("""main.py [OPTIONS] 
    Solve the matasano crypto challenges. Defualt runs current challenge

Mandatory arguments to long options are mandatory for short options too.
    -a, --all \t\t run all 
    -q, --quick \t run quick challenges (default)

""")

def run(l):
    for n in l:
        fn = complete[n]
        print(fn())

def regtest():
    for n in list_quick:
        fn = complete[n]
        res = fn()
        if res.find('Completed') == -1:
            print(res)
        
complete = {
    1: chal_1,
    2: chal_2,
    3: chal_3,
    4: chal_4,
    5: chal_5,
    6: chal_6,
    7: chal_7,
    8: chal_8,
    9: chal_9,
    10: chal_10,
    11: chal_11,
    12: chal_12,
    13: chal_13,
    14: chal_14,
    15: chal_15,
    16: chal_16,
    17: chal_17,
    18: chal_18,
    19: chal_19,
    20: chal_20,
    21: chal_21,
    22: chal_22,
    23: chal_23,
    24: chal_24,
}

list_all = [ 1, 2, 3, 4, 5, 6, 7, 8,
             9 ,10, 11, 12, 13, 14, 15, 16,
             17, 18, 19, 20, 21, 22, 23, 24]

list_quick = [ 1, 2, 3, 5, 6, 7, 8, 9 ,10,
             11, 12, 13, 14, 15, 16,
               18, 19, 20, 21, 22, 23, 24]

current = 17

if r == True:
    regtest()
elif a == True:
    run(list_all)
elif q == True:
    run(list_quick)
else:
    fn = complete[current]
    print(fn())
