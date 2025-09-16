#!/usr/bin/gawk -f

BEGIN {
    FS="|"
    OFS="\t"
}

# reading in from /data/raw/census/2010-2020-populations/2020.gz
{
    # filter NY zipcodes, output zip and population
    ZIP = int(substr($2, 6))
    if (ZIP >= 10000 && ZIP <= 12345)
	print ZIP, $3
}
