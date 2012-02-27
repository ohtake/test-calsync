#!/bin/bash
if [ -f config.sh ]; then
  . config.sh
fi
git checkout gh-pages
wget $ICAL_URI -O private.ics
# Simplify SUMMARY (single UCS-2 char in UTF-8) and drop DESCRIPTION
perl -pe 's/^SUMMARY:([\x00-\x7F]|[\xC2-\xDF][\x80-\xBF]|\xE0[\xA0-\xBF][\x80-\xBF]|[\xE1-\xEF][\x80-\xBF][\x80-\xBF]).*/SUMMARY:\1/g' < private.ics | grep -v ^DESCRIPTION > public.ics
git add public.ics
git commit -m "$COMMENT"
# Uncomment this
# git push $REMOTE_GIT gh-pages

