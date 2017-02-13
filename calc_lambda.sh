if [ "$1" == "" ]
then
	echo "Please give METAL output file as parameter."
	exit 3
fi

FN=$1
if [ ! -f "$FN" ]
then
	echo "Input file not found: $FN"
	exit 3
fi

NSTUD="2"
if [ "$2" != "" ]
then
	NSTUD=$2
	echo "Use NSTUD filter from commandline: $NSTUD"
else
	echo "Use default NSTUD filter: $NSTUD"
fi


cat $FN | awk -v nstud_filter=$NSTUD '{ 
	if (FNR > 1) {
		pval = $10;
		isq = $12;
		nstud = $14 + 1;
		if (nstud >= nstud_filter) {
			print pval, $11;
		}
	} else {
		print "pval", "directions";
	} }' > ${FN}.pval

Rscript /shared/metaanalysis/scripts/lambda.R ${FN}.pval
