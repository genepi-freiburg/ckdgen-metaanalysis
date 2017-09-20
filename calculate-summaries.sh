#!/bin/bash

OUTFILE=datamash_summaries.txt

echo -n "File Name	N total	N rows	" > $OUTFILE
echo -n "Beta_N	Beta_MEAN	Beta_MEDIAN	Beta_SD	Beta_MIN	Beta_MAX	Beta_Q1	Beta_Q3	Beta_Skewness	" >> $OUTFILE
echo -n "SE_N	SE_MEAN	SE_MEDIAN	SE_SD	SE_MIN	SE_MAX	SE_Q1	SE_Q3	SE_Skewness	" >> $OUTFILE
echo -n "PVAL_N	PVAL_MEAN	PVAL_MEDIAN	PVAL_SD	PVAL_MIN	PVAL_MAX	PVAL_Q1	PVAL_Q3	" >> $OUTFILE
echo -n "AF_coded_all_N	AF_coded_all_MEAN	AF_coded_all_MEDIAN	AF_coded_all_SD	AF_coded_all_MIN	AF_coded_all_MAX	AF_coded_all_Q1	AF_coded_all_Q3	" >> $OUTFILE
echo "IQ_N	IQ_MEAN	IQ_MEDIAN	IQ_SD	IQ_MIN	IQ_MAX	IQ_Q1	IQ_Q3" >> $OUTFILE

rm -f calculate_summaries.log

for FN in `ls -1 input_HQ/*.gwas.gz`
do
        BN=`basename $FN`
        echo "---------------------------------------------"
        echo "Calculate summaries for $BN"
        echo "---------------------------------------------"
        /shared/metaanalysis/scripts/calculate-summaries-for-file.sh $BN >> $OUTFILE 2>>calculate_summaries.log
done

