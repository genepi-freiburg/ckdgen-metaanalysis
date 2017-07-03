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

NSTUD="0"
if [ "$2" != "" ]
then
	NSTUD=$2
	echo "Use NSTUD filter from commandline: $NSTUD"
else
	echo "Use default NSTUD filter: $NSTUD"
fi


OUTFN=${FN}_nstud${NSTUD}.pval
rm -fv ${OUTFN}

cat $FN | awk -F $'\t' -v nstud_filter=$NSTUD 'BEGIN {OFS = FS} { 
	if (FNR > 1) {
		pval = $10;
		isq = $12;
		nstud = $14 + 1;
		if (nstud >= nstud_filter) {
			gsub(/ /, "", pval);
			print pval, $1;
		}
	} else {
		print "pval", "ID";
	} }' > ${OUTFN}

Rscript /shared/metaanalysis/scripts/lambda.R ${OUTFN}
