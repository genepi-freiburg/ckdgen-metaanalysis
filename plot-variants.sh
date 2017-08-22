FL=$1
if [ ! -f "$FL" ]
then
	echo "Expect file with GWAS file names as input."
	exit 3
fi

COUNTFILE=variant-counts.txt
rm -f $COUNTFILE

for FN in `cat $FL`
do
	echo "Process $FN: Count variants per chromosome"
	/shared/cleaning/scripts/count-variants.sh $FN | tee -a $COUNTFILE
done

Rscript /shared/metaanalysis/scripts/rainbox-plot.R $COUNTFILE

