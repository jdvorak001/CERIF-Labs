#!/bin/sh
for F in "$@"
do
	L=$(basename $F)
	tidy -n --doctype omit -utf8 --wrap 0 -f $F.log $F | \
	sed -e 's#href="\(.*/en\)"#href="\1.xml"#' -e 's#href="\(.*/nl\)"#href="\1.xml"#' \
		-e 's#href="\(.*/ORG[0-9][0-9][0-9][0-9][0-9][0-9][0-9]\)"#href="\1/Language/'$L'.xml"#' >$F.xml
done
