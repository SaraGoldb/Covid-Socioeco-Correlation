#!/usr/bin/gawk -f

BEGIN {
    FS="\t"
    OFS="\t"

    # Read in drug histo into an array
    while ((getline < "normHistoDrug") > 0)
	drug[$1] = $4
    close("normHistoDrug")

    # load income per zip
    # Note: this file also has population, but the numbers are different
    # than the uszips.txt file. Maybe just use this file for pop?
    while ((getline < "./cleanIncome") > 0) {
	income = $2
	if (income == "250,000+") income = 250000
	if (income == "-")        income = 0
	zip_income[$1] = income
    }
    close("./cleanIncome")

    
    print "ZIP", "DRUG", "COVID", "INCOME_MEDIAN"
}

# Read in covid histo and output zip, drug tally per capita, and covid tally per capita
{
    if (drug[$1] && zip_income[$1] && zip_income[$1] > 0)
	    print $1, drug[$1], $4, zip_income[$1]
}
