MYFILE=metal-params.txt
if [ -f $MYFILE ]
then
	echo "Metal parameters already exist: $MYFILE"
	exit 3
fi

ANALYSISNAME=$(basename `pwd`)
echo "Analysis name: $ANALYSISNAME"


cat /shared/metaanalysis/scripts/metal-params.txt |
	sed s/%ANALYSISNAME%/$ANALYSISNAME/ > $MYFILE

for FN in `ls -1 input/*.gz`
do
	echo "PROCESS $FN" >> $MYFILE
done

echo >> $MYFILE
echo "ANALYZE HETEROGENEITY" >> $MYFILE
echo "QUIT" >> $MYFILE

echo "done"
