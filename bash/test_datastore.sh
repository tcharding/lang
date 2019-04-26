#!/bin/bash
#
# run OB datastore tests
if [ -e test.db ]
then
        rm test.db
fi

nosetests -vs --with-coverage --cover-package=db db/tests
