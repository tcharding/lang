#!/usr/bin/env python
"""Mixed output to stdout and stderr"""
import sys
print >>sys.stderr, "This is an error msg"
print "This is to stdout"
print >>sys.stdout, "Stdout also"
