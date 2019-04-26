#!/bin/bash
#
# Find leaking kernel addresses

# exclude certs, drivers, firmware, samples, scripts, tools
dirs=( arch block crypto fs include kernel lib mm net security sound virt drivers )
for dir in ${dirs[@]}
do
    cd $dir
    echo -n "$dir: "
    git grep '%p[^KFfSsBRrbMmIiEUVKNhdDgCGO]' | wc -l
    cd ..
done
