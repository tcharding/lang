#!/bin/bash
#
# update function calls for funcitons in create/

k8s=~/build/go/src/k8s.io
names=$(cat ~/build/go/src/k8s.io/fn-names)
kc_cmd_dir="$k8s/kubernetes/pkg/kubectl/cmd"

files=$(find $kc_cmd_dir -maxdepth 1 -name '*.go')
for fn in $names
do
    for file in $files
    do
#        echo "updating $fn in $file"
        perl -pi -e "s/$fn/create\.$fn/g" $file
    done
done
