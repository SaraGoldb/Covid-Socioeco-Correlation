#!/usr/bin/gawk -f

# Step 3: Normalize the data per capita (divide cases by population size)

BEGIN {
    
    FS="\t"
    OFS="\t"

    # load zips 
    while ((getline < "./cleanPop") > 0)
	zip_pops[$1] = $2
    close("./cleanZips")

    #print "ZIPS"
    #for (zip in zip_pops)
	#print zip, zip_pops[zip]

    # header line
    #print "ZIP", "POP", "TALLY", "NORM"
}

# Reading in from histoCovid or histoDrug
{
    ZIP   = $1
    tally = $2
    pop  = zip_pops[ZIP]
    
    # Note: Some zipcodes are not residential, and therefore have no population
    # don't output these zips as it will skew the study
    if (pop > 100) {
	print ZIP, pop, tally, tally/pop*100
        count++
    }
}

#END {
#    print "FOUND " count " ROWS"
#}

### JUNK DRAWER ###
    #if (pop == "") pop = 0
    #if (pop == 0) norm = 0
    #else norm = tally/pop
