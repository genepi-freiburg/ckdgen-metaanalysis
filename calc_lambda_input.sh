if [ "$1" == "" ]
then
	echo "Please give input file as parameter."
	exit 3
fi

FN=$1
if [ ! -f "$FN" ]
then
	echo "Input file not found: $FN"
	exit 3
fi

OUTFN=${FN}.pval
rm -fv ${OUTFN}

PVAL_COL=`/shared/cleaning/scripts/find-column-index.pl pval $FN`
if [ "$PVAL_COL" == "-1" ]
then
	echo "'pval' column not found in: $FN"
	exit 3
else
	echo "'pval' column index found: $PVAL_COL"
fi

zcat $FN | awk -v pval_col=$PVAL_COL '{ 
	if (FNR > 1) {
		pval = $(pval_col+1);
		print pval;
	} else {
		print "pval";
	} }' > ${OUTFN}

Rscript /shared/metaanalysis/scripts/lambda.R ${OUTFN}
