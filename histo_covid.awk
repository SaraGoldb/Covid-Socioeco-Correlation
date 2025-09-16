#!/usr/bin/gawk -f

# Tally up EMS calls with COVID symptoms per ZIP code for March 2020 - March 2022 (inclusive)
# accept command line arguments so that I can split data into thre seperate histo's based on three COVID peaks

# Using the clean EMS data
# if field 3 INITIAL_CALL_TYPE contains a COVID symptom
# (may want to do something with field 4 FINAL_CALL_TYPE)
# and field 1 INCIDENT_DATETIME is within 3/2020 and 3/2022
# count it towards its ZIPCODE (field 2) tally
# at the end, print the zipcodes with their tallies

BEGIN {
    # load covid symptoms list
    while ((getline < "./codes_covid") > 0)
	codes[$1] = $1
    close("./codes_covid")

    #for (c in codes)
	#print c

    #print m1, y1, m2, y2
    
    # reading in cleaned EMS file, field seperator is a pipe
    # and I want the output field seperator to be a pipe
    FS = "|"
    OFS = "\t"
}

# read in clean EMS calls file
{
    # using fields 1 (INCIDENT_DATETIME), 2 (ZIPCODE), and 3 (INITIAL_CALL_TYPE)
    # if field 3 is a covid symptom and date is within range, increment the counter for that ZIP
    month = int(substr($1, 6, 2))
    year  = substr($1, 1, 4)
    inrange = 0

    # test if date is in range
    if (y1 == y2) {
	if (y1 == year && month >= m1 && month <= m2)
	 inrange = 1
    } else if (y2 > y1) {
	if ((year == y1 && month >= m1) || (year == y2 && month <= m2))
	    inrange = 1
    }

    #print inrange, year " " month
    
    if ($3 in codes && $4 in codes && inrange == 1) {
	#print year " " month
	count++
	tally[$2]++
    }
}

END {
    #print "Found " count " covid calls"
    
    # output valid zipcodes
    for (ZIP in tally)
	if (ZIP !~ /10000|12345|83/)
	    print ZIP, tally[ZIP]
}
