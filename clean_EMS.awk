#!/usr/bin/gawk -f

BEGIN {
    FS="\t"
    OFS="|"
}

# Reading in from gzip EMS tsv file
{
    # Clean up file to output YYYY/MM/DD|ZIP|ICT|FCT
    # only output lines that contain a zipcode
    # and only include years from 2017-2022
    # use fields 2 (INCIDENT_DATETIME), 22 (ZIPCODE), 3 (INITIAL_CALL_TYPE), and 5 (FINAL_CALL_TYPE)
    year = substr($2, 7, 4)
    if ($22 != "" && year ~ /2019|2020|2021|2022/)
	print year "/" substr($2, 1, 5), $22, $3, $5
}
