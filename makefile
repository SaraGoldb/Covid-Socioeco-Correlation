# NOTE: Must `activate` to run plot.py

all: cleanEMS cleanPop cleanIncome histoCovid1 histoCovid2 histoCovid3 histoDrug normHistoCovid1 normHistoCovid2 normHistoCovid3 normHistoDrug comboHisto1 comboHisto2 comboHisto3 plots.pdf

clean:
	rm cleanEMS cleanPop cleanIncome histoCovid1 histoCovid2 histoCovid3 histoDrug normHistoCovid1 normHistoCovid2 normHistoCovid3 normHistoDrug comboHisto1 comboHisto2 comboHisto3 plots.pdf



## CLEAN UP DATA FILES ##

# clean up gzip file to output YYYY/MM/DD|ZIP|ICT|FCT from years 2019-2022 and which contain ZIP codes
cleanEMS: clean_EMS.awk /data/raw/NYC_EMS_Incidents/EMS_Incident_Dispatch_Data_20241110.tsv.gz
	zcat /data/raw/NYC_EMS_Incidents/EMS_Incident_Dispatch_Data_20241110.tsv.gz | ./clean_EMS.awk > cleanEMS

# filter population file for NY ZIP codes, output ZIP and population
cleanPop: clean_pop.awk /data/raw/census/2010-2020-populations/2020.gz
	zcat /data/raw/census/2010-2020-populations/2020.gz | ./clean_pop.awk > cleanPop

# filter Census income file for NY ZIP codes, output ZIP and median income
cleanIncome: clean_income.awk /data/raw/census/medianIncomeByZIP/medianIncomeByZIP2022.txt
	./clean_income.awk < /data/raw/census/medianIncomeByZIP/medianIncomeByZIP2022.txt > cleanIncome



## CREATE HISTOs ##

# filter EMS calls where INITIAL_CALL_TYPE and FINAL_CALL_TYPE are a covid symptom, and tally per ZIP
# for each of the 3 peak dates determined by the CDC's COVID tracker for NY
# NOTE: use arg v to get the 3 peak dates

# Peak 1: March 2020 - May 2020
histoCovid1: histo_covid.awk cleanEMS codes_covid
	./histo_covid.awk -v m1=3 -v y1=2020 -v m2=5 -v y2=2020 < cleanEMS > histoCovid1

# Peak 2: November 2020 - May 2021
histoCovid2: histo_covid.awk cleanEMS codes_covid
	./histo_covid.awk -v m1=11 -v y1=2020 -v m2=5 -v y2=2021 < cleanEMS > histoCovid2

# Peak 3: Nov 2021 - Feb 2022
histoCovid3: histo_covid.awk cleanEMS codes_covid
	./histo_covid.awk -v m1=11 -v y1=2021 -v m2=2 -v y2=2022 < cleanEMS > histoCovid3


# filter EMS drug calls for the year 2019 where INITIAL_CALL_TYPE and FINAL_CALL_TYPE are DRUG and tally per ZIP
histoDrug: histo_drug.awk cleanEMS
	./histo_drug.awk < cleanEMS > histoDrug



## NORMALIZE HISTOs ##

# normalize covid histo from peak 1 by population
normHistoCovid1: norm_histo.awk histoCovid1 cleanPop
	./norm_histo.awk < histoCovid1 > normHistoCovid1

# normalize covid histo from peak 2 by population
normHistoCovid2: norm_histo.awk histoCovid2 cleanPop
	./norm_histo.awk < histoCovid2 > normHistoCovid2

# normalize covid histo from peak 3 by population
normHistoCovid3: norm_histo.awk histoCovid3 cleanPop
	./norm_histo.awk < histoCovid3 > normHistoCovid3

# normalize drug histo by population
normHistoDrug: norm_histo.awk histoDrug cleanPop
	./norm_histo.awk < histoDrug > normHistoDrug



## COMBINE HISTOs AND INCOME FOR PLOTTING ##

# Combine drug and covid peak 1 tallies on ZIP code and include median income per ZIP
comboHisto1: combo_histo.awk normHistoDrug normHistoCovid1 cleanIncome
	./combo_histo.awk  < normHistoCovid1 > comboHisto1

# Combine drug and covid peak 2 tallies on ZIP code and include median income per ZIP
comboHisto2: combo_histo.awk normHistoDrug normHistoCovid2 cleanIncome
	./combo_histo.awk < normHistoCovid2 > comboHisto2

# Combine drug and covid peak 3 tallies on ZIP code and include median income per ZIP
comboHisto3: combo_histo.awk normHistoDrug normHistoCovid3 cleanIncome
	./combo_histo.awk < normHistoCovid3 > comboHisto3



## PLOT DATA ##

# Must `activate` to use matplotlib
# plot the three combined histos and save into a pdf
# with plots that isolate low, medium, and high income for easy comparison
plots.pdf: plot.py
	./plot.py
