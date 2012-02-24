$ICAL_URI = 'http://example.com/hoge.ics'
# Cannot upload *.ics files to SkyDrive WebDAV, so add .txt extension
$DEST = 'S:\Public\hoge.ics.txt'

wget $ICAL_URI -O private.ics
cat private.ics -Encoding UTF8 |
	# Drop DESCRIPTION
	Select-String "^DESCRIPTION" -NotMatch |
	# Simplify SUMMARY
	% {$_ -replace "^SUMMARY:(.)?.*",'SUMMARY:$1'} |
	Out-File public.ics -Encoding UTF8
cp public.ics $DEST
