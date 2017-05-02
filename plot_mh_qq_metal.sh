FN=$1
if [ "$FN" == "" ]
then
	echo "Please give METAL file as first argument."
	exit 3
fi

if [ ! -f "$FN" ]
then
	echo "Input does not exist: $FN"
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

OUT=${FN}_nstud${NSTUD}.epacts

cat $FN | awk -v nstud_filter=$NSTUD '{ 
	if (FNR > 1) {
		marker = $1;
		af = $4;
		pval = $10;
                nstud = $14 + 1;
		if (af > 0.5) {
			af = 1 - af;
		}
		split(marker, marker_array, "_");
		chr = marker_array[1];
 		pos = marker_array[2];
		if (nstud >= nstud_filter) {
			print chr + 0, pos + 0, pos + 1, af, pval;
		}
	} else {
		print "#CHR", "BEGIN", "END", "MAF", "PVALUE";
	} }' > ${OUT}

/shared/metaanalysis/bin/EPACTS-3.2.6/bin/epacts-plot -in ${OUT}
