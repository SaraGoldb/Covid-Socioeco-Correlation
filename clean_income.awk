#!/usr/bin/gawk -f

BEGIN {
    FS="\t"
    OFS="\t"
}

# reading in from Census income data
{    
    # filter only NY zipcodes, output ZIP and median income
    ZIP = int(substr($2, 6))
    if (ZIP >= 10000 && ZIP <= 12345)
	print ZIP, $163
}
