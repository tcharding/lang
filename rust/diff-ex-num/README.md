diff excluding numbers
======================

Compare two files for textual differences.  Exclude comparison of numbers i.e.,
two numbers do not differ if only their value differs.  Do check number format.

For example:

- 1.0 is different to 1
- 100K is different to 100
- 12/10/11 is the same as 13/10/9

This tool may be used to compare the output of commands that include numbers
that differ depending on when the tool was run i.e., to check that the output
format is the same even though the content is different.
