#!/usr/bin/gawk -f

# Step 2: tally up EMS calls with DRUG symptoms per ZIP code for March 2017 - March 2019 (inclusive)

# Using the clean EMS data
# if field 3 INITIAL_CALL_TYPE is DRUG
# (may want to do something with field 4 FINAL_CALL_TYPE)
# and field 1 INCIDENT_DATETIME is in baseline range 03/2017 - 03/2019
# count it towards its ZIPCODE (field 2) tally
# at the end, print the zipcodes with their tallies

BEGIN {
    # reading in cleaned EMS file, field seperator is a pipe
    # and I want the output field seperator to be a pipe
    FS = "|"
    OFS = "\t"
}

# read in clean EMS calls file
{
    # using fields 1 (INCIDENT_DATETIME), 2 (ZIPCODE), and 3 (INITIAL_CALL_TYPE)
    # if field 3 is a drug symptom and date is within range, increment the counter for that ZIP
    year  = substr($1, 1, 4)
    if ($3 == "DRUG" && $4 == "DRUG" && year == "2019"){
	#print $1, $2, $3
	count++
	tally[$2]++
    }
}

END {
    #print "Found " count " drug calls"

    # output valid zipcodes
    for (ZIP in tally)
	if (ZIP !~ /10000|12345|83/)
	    print ZIP, tally[ZIP]
}
