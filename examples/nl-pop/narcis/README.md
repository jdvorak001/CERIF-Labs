# Getting relevant info from narcis.nl

For the two universities (Utrecht and Radbout) we retreive their organisational structure and the pages of current & completed research:

	wget --no-verbose -r -l inf --no-remove-listing --wait 0.2 --random-wait -e robots=off --accept-regex 'http://www\.narcis\.nl/organisation(res[cd])?/RecordID/.*/Language/' http://www.narcis.nl/search/coll/organisation/Language/EN/dd_institute/U_RUU http://www.narcis.nl/search/coll/organisation/Language/EN/dd_institute/U_KUN

	Total wall clock time: 9m 16s
	Downloaded: 970 files, 12M in 1m 31s (132 KB/s)
	

Then retrieve the projects mentioned in these organisational units:

	find www.narcis.nl/organisation* -type f | xargs grep -h /research/RecordID | sed -e 's/^.*\.\.\/research/http:\/\/www.narcis.nl\/research/' -e 's/">.*//' | sort | uniq | xargs -P 3 -n 100 wget --no-verbose -r -l inf --no-remove-listing --wait 0.2 --random-wait -e robots=off --accept-regex 'http://www\.narcis\.nl/research/RecordID/.*/Language/'

Then retrieve the persons and organisations mentioned in these projects (only those org units that were not retrieved previously):

	ls www.narcis.nl/organisation/RecordID/*/Language/?? | sed -e 's/^/http:\/\//' >orgs1.lst
	find www.narcis.nl/research/RecordID/ -type f | xargs sed -n -e '/\/person\/RecordID/p' -e '/\/organisation\/RecordID/p' | sed -e 's/^.*\.\.\/person/http:\/\/www.narcis.nl\/person/' -e 's/">.*//' -e 's/^.*\.\.\/organisation/http:\/\/www.narcis.nl\/organisation/' -e 's/">.*//' | sort | uniq | join -v1 - orgs1.lst | xargs -P 8 -n 200 wget --no-verbose -x --wait 0.2 --random-wait -e robots=off
	
And eventually, retrieve the org units that were not retrieved previously:

	ls www.narcis.nl/organisation/RecordID/*/Language/?? | sed -e 's/^/http:\/\//' >orgs2.lst ; find www.narcis.nl/organisation/RecordID www.narcis.nl/research/RecordID www.narcis.nl/person/RecordID -type f | xargs grep -h /organisation/RecordID | grep -v '</head>' | sed -e 's/^.*\.\.\/organisation/http:\/\/www.narcis.nl\/organisation/' -e 's/\"\>.*//' -e 's/\/Language\/..//' | sort | uniq | awk '{ print $0 "/Language/en"; print $0 "/Language/nl"; }' | join -v1 - orgs2.lst | time xargs -P 8 -n 200 wget --no-verbose -x --wait 0.2 --random-wait -e robots=off
	
Repeat several times until the set of orgunits is closed (no new orgunits are retrieved):

	find www.narcis.nl/organisation/RecordID -name en -o -name nl | grep -v /dd_institute/ | sed -e 's/^/http:\/\//' >orgs2.lst ; find www.narcis.nl/organisation/RecordID -name en -o -name nl | xargs grep -h '\.\./\.\./ORG' | grep -v '</head>' | sed -e 's/^.*\.\.\/ORG/http:\/\/www.narcis.nl\/organisation\/RecordID\/ORG/' -e 's/\"\>.*//' -e 's/\/Language\/..//' | sort | uniq | awk '{ print $0 "/Language/en"; print $0 "/Language/nl"; }' | join -v1 - orgs2.lst | time xargs -P 8 -n 200 wget --no-verbose -x --wait 0.2 --random-wait -e robots=off


Use *tidy* to clean up the XHTML and convert links:

	find www.narcis.nl/organisation/RecordID www.narcis.nl/research/RecordID www.narcis.nl/person/RecordID -name en -o -name nl | grep -v dd_institute | time xargs -P 50 -n 10 ./tidy-up.sh 
	


## Get the discipline classification system of Narcis:

	wget -x http://www.narcis.nl/drilldownitems/coll/organisation/Language/EN/ddall/dd_cat
	wget -x http://www.narcis.nl/drilldownitems/coll/organisation/Language/nl/ddall/dd_cat
	# rename the English directory
	mv www.narcis.nl/drilldownitems/coll/organisation/Language/EN www.narcis.nl/drilldownitems/coll/organisation/Language/en
	
	# tidy up 
	find www.narcis.nl/drilldownitems -name dd_cat | xargs ./tidy-up.sh
	
	# fix the translation links
	find www.narcis.nl/drilldownitems -name dd_cat.xml | ( while read F ; do sed -e 's#/ddall/dd_cat"#/ddall/dd_cat.xml"#' $F >$F.1 && mv $F.1 $F ; done )

And now transform it into a XML Schema with embedded CERIF semantic layer XML fragments:

	cd ..
	ant subjects2xs
