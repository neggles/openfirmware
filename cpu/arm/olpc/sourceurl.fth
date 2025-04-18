\ Make a file containing the URL of the source code

show-rebuilds?  false to show-rebuilds?   \ We don't need to see these commands

" git remote -v | grep origin | cut -f2 | cut -f1 -d' ' | tr \\n ' ' > sourceurl ; git rev-parse --abbrev-ref HEAD >>sourceurl ; git status --porcelain | wc -l >>sourceurl" $sh

to show-rebuilds?
