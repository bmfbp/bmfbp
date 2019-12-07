#!/usr/bin/env

local_projects=$HOME/quicklisp/local-projects

mkdir -p ${local_projects}

repos=""
repos+="https://github.com/norvig/paip-lisp "
repos+="https://github.com/guitarvydas/loops "


cd ${local_projects}
for repo in $repos; do
    git clone ${repo}
done
    
