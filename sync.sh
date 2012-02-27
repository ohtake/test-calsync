#!/bin/bash
. config.sh
git checkout gh-pages
wget $ICAL_URI -O private.ics
# Simplify SUMMARY and drop DESCRIPTION
sed 's/^SUMMARY:\(.\).*/SUMMARY:\1/g' private.ics | grep -v ^DESCRIPTION > public.ics
git add public.ics
git commit -m "test"
# Uncomment this
# git push $REMOTE_GIT gh-pages

