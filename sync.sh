#!/bin/bash
if [ -f config.sh ]; then
  . config.sh
fi
git checkout gh-pages
powershell.exe outlook2ical.ps1
git add -N public.ics
git add public.ics `[ "$INTERACTIVE" = "true" ] && echo "-p"`
git commit -m "$COMMENT"
[ "$AUTO_PUSH" = "true" ] &&  git push "$REMOTE_GIT" gh-pages

