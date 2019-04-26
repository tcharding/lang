#!/bin/bash
#
# SPHINX breaks constantly, run suggested commands to fix it.
/usr/bin/virtualenv sphinx_1.4
source sphinx_1.4/bin/activate
pip install -r Documentation/sphinx/requirements.txt

