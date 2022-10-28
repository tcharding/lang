#!/bin/bash
#
# Check for open PRs that need rebasing in order to be mergable into master.

PR_FILE=/home/tobin/tmp/open_prs

main() {
    rm -f "$PR_FILE"
    get_all_open_non_draft_prs

    branches=$(cat $PR_FILE)

    conflicts=("")

    for branch in $branches; do
        echo "Checking $branch"
        git checkout --quiet "$branch"
        git checkout --quiet -b _tmp_rebase

        git rebase --quiet master 2> /dev/null
        if [ $? -ne 0 ]; then
            conflicts+=("$branch")
            git rebase --abort
        fi

        git checkout --quiet master
        git branch --quiet -D _tmp_rebase
    done

    echo "Merge conflicts found in branches: "
    for branch in "${conflicts[@]}"; do
        echo "$branch"
    done
}

get_all_open_non_draft_prs() {
    gh pr list --author tcharding  | \
        awk '{ if ($NF == "OPEN") { split($(NF-1),a,":"); print a[2] } }' > "$PR_FILE"
}

#
# Main script
#
main $@
exit 0
