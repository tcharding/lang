__all__ = ['ran']

def ran(chal, exp, got):
    (setn, chaln) = chal
    
    s = ("Set %s, Challenge %s: " % (setn, chaln))
    if exp == got:
        s += ("Completed!")
    else:
        s += ("Failed. ")
        s += ("\n\te:%s\n" % exp)
        s += ("\tg:%s" % got)

    return s


# def run(chal, expected, ):
#     (setn, chaln) = chal
#     print("Set %s, Challenge %s: " % (setn, chaln), end="")
#     if result == expected:
#         print("Completed!")
#     else:
#         print("Failed")
#         print("e:%s" % expected)
#         print("g:%s" % result)
