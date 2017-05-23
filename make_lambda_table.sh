IN_DIR=$1
CALC_LAMBDA="/shared/metaanalysis/scripts/calc_lambda_input.sh"
OUT_FN=$2

echo "Read dir: $IN_DIR"
echo "Write to: $OUT_FN"

echo "FILE	LAMBDA" > $OUT_FN

for FN in `ls -1 $IN_DIR/*.gz`
do
	echo "Process file: $FN"
	LAMBDA_FN="${FN}.lambda"
	$CALC_LAMBDA $FN | tee ${LAMBDA_FN}
	LAMBDA_VAL=`cat $LAMBDA_FN | grep "lambda: " | awk '{print $3}' | sed 's/"//'`
	rm -f $LAMBDA_FN
	BN=`basename $FN`
	echo "${BN}	${LAMBDA_VAL}" >> $OUT_FN
	echo "Got Lambda: $LAMBDA_VAL"
done
