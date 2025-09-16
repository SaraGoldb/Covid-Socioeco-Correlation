#!/usr/bin/gawk -f

BEGIN {
    
    FS="\t"
    OFS="\t"

    # load clean uszips file
    while ((getline < "./cleanZips") > 0)
	uszips[$1] = $2
    close("./cleanZips")

    # Print header
    print "ZIP", "uszips", "IncomeP", "diff"

    # Eat up header line from IncomePop file
    getline < "./cleanIncome"
    
    # load clean Incomepop.gz file and print
    while ((getline < "./cleanIncome") > 0) {
	diff = uszips[$1] - $4
	abs_diff = (diff >= 0) ? diff : -diff
	print $1, uszips[$1], $4, abs_diff
    }
    close("./cleanIncome")

}
