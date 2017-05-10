BN=$1
if [ "$BN" == "" ]
then
	echo "Input basename missing"
	exit 3
fi

QCTXT="gwasqc/gwasqc${BN}.txt"

if [ ! -f $QCTXT ]
then
	echo "QC text file missing: $QCTXT"
	exit 3
fi


NROWS=`cat $QCTXT | grep "Sample size" -A 2 | grep "N" | awk '{print $3}'`
NTOTAL=`cat $QCTXT | grep "Sample size" -A 7 | grep "Median" | awk '{print $3}'`

>&2 echo "Sample Size: n(rows) = $NROWS, n(total) = $NTOTAL"

BETA_N=`cat $QCTXT | grep "Effect size (beta)" -A 2 | grep "N " | awk '{ print $3 }'`
BETA_MEAN=`cat $QCTXT | grep "Effect size (beta)" -A 19 | grep "Mean" | awk '{ print $3 }'`
BETA_MEDIAN=`cat $QCTXT | grep "Effect size (beta)" -A 19 | grep "Median" | awk '{ print $4 }'`
BETA_SD=`cat $QCTXT | grep "Effect size (beta)" -A 19 | grep "StdDev" | awk '{ print $3 }'`
BETA_MIN=`cat $QCTXT | grep "Effect size (beta)" -A 19 | grep "Min" | awk '{ print $4 }'`
BETA_MAX=`cat $QCTXT | grep "Effect size (beta)" -A 19 | grep "Max" | awk '{ print $4 }'`
BETA_Q1=`cat $QCTXT | grep "Effect size (beta)" -A 19 | grep "25%" | awk '{ print $3 }'`
BETA_Q3=`cat $QCTXT | grep "Effect size (beta)" -A 19 | grep "75%" | awk '{ print $3 }'`

>&2 echo "Beta: N = $BETA_N, mean = $BETA_MEAN, median = $BETA_MEDIAN, sd = $BETA_SD, min = $BETA_MIN, max = $BETA_MAX, q1 = $BETA_Q1, q3 = $BETA_Q3"




SE_N=`cat $QCTXT | grep "Standard error (SE)" -A 10 | grep "N " | awk '{ print $3 }'`
SE_MEAN=`cat $QCTXT | grep "Standard error (SE)" -A 19 | grep "Mean" | awk '{ print $3 }'`
SE_MEDIAN=`cat $QCTXT | grep "Standard error (SE)" -A 19 | grep "Median" | awk '{ print $4 }'`
SE_SD=`cat $QCTXT | grep "Standard error (SE)" -A 19 | grep "StdDev" | awk '{ print $3 }'`
SE_MIN=`cat $QCTXT | grep "Standard error (SE)" -A 19 | grep "Min" | awk '{ print $4 }'`
SE_MAX=`cat $QCTXT | grep "Standard error (SE)" -A 25 | grep "Max" | awk '{ print $4 }'`
SE_Q1=`cat $QCTXT | grep "Standard error (SE)" -A 19 | grep "25%" | awk '{ print $3 }'`
SE_Q3=`cat $QCTXT | grep "Standard error (SE)" -A 25 | grep "75%" | awk '{ print $3 }'`

>&2 echo "SE: N = $SE_N, mean = $SE_MEAN, median = $SE_MEDIAN, sd = $SE_SD, min = $SE_MIN, max = $SE_MAX, q1 = $SE_Q1, q3 = $SE_Q3"


PVAL_N=`cat $QCTXT | grep "P-value (pval)" -A 10 | grep "N " | awk '{ print $3 }'`
PVAL_MEAN=`cat $QCTXT | grep "P-value (pval)" -A 19 | grep "Mean" | awk '{ print $3 }'`
PVAL_MEDIAN=`cat $QCTXT | grep "P-value (pval)" -A 19 | grep "Median" | awk '{ print $4 }'`
PVAL_SD=`cat $QCTXT | grep "P-value (pval)" -A 19 | grep "StdDev" | awk '{ print $3 }'`
PVAL_MIN=`cat $QCTXT | grep "P-value (pval)" -A 19 | grep "Min" | awk '{ print $4 }'`
PVAL_MAX=`cat $QCTXT | grep "P-value (pval)" -A 25 | grep "Max" | awk '{ print $4 }'`
PVAL_Q1=`cat $QCTXT | grep "P-value (pval)" -A 19 | grep "25%" | awk '{ print $3 }'`
PVAL_Q3=`cat $QCTXT | grep "P-value (pval)" -A 25 | grep "75%" | awk '{ print $3 }'`

>&2 echo "PVAL: N = $PVAL_N, mean = $PVAL_MEAN, median = $PVAL_MEDIAN, sd = $PVAL_SD, min = $PVAL_MIN, max = $PVAL_MAX, q1 = $PVAL_Q1, q3 = $PVAL_Q3"


AF_N=`cat $QCTXT | grep "Minor allele frequency" -A 10 | grep "N " | awk '{ print $3 }'`
AF_MEAN=`cat $QCTXT | grep "Minor allele frequency" -A 19 | grep "Mean" | awk '{ print $3 }'`
AF_MEDIAN=`cat $QCTXT | grep "Minor allele frequency" -A 19 | grep "Median" | awk '{ print $4 }'`
AF_SD=`cat $QCTXT | grep "Minor allele frequency" -A 19 | grep "StdDev" | awk '{ print $3 }'`
AF_MIN=`cat $QCTXT | grep "Minor allele frequency" -A 19 | grep "Min (0%)" | awk '{ print $4 }'`
AF_MAX=`cat $QCTXT | grep "Minor allele frequency" -A 25 | grep "Max" | awk '{ print $4 }'`
AF_Q1=`cat $QCTXT | grep "Minor allele frequency" -A 19 | grep "25%" | awk '{ print $3 }'`
AF_Q3=`cat $QCTXT | grep "Minor allele frequency" -A 25 | grep "75%" | awk '{ print $3 }'`

>&2 echo "AF_coded_all: N = $AF_N, mean = $AF_MEAN, median = $AF_MEDIAN, sd = $AF_SD, min = $AF_MIN, max = $AF_MAX, q1 = $AF_Q1, q3 = $AF_Q3"




IQ_N=`cat $QCTXT | grep "Imputation quality" -A 10 | grep "N " | awk '{ print $3 }'`
IQ_MEAN=`cat $QCTXT | grep "Imputation quality" -A 19 | grep "Mean" | awk '{ print $3 }'`
IQ_MEDIAN=`cat $QCTXT | grep "Imputation quality" -A 19 | grep "Median" | awk '{ print $4 }'`
IQ_SD=`cat $QCTXT | grep "Imputation quality" -A 19 | grep "StdDev" | awk '{ print $3 }'`
IQ_MIN=`cat $QCTXT | grep "Imputation quality" -A 19 | grep "Min" | awk '{ print $4 }'`
IQ_MAX=`cat $QCTXT | grep "Imputation quality" -A 25 | grep "Max" | awk '{ print $4 }'`
IQ_Q1=`cat $QCTXT | grep "Imputation quality" -A 19 | grep "25%" | awk '{ print $3 }'`
IQ_Q3=`cat $QCTXT | grep "Imputation quality" -A 25 | grep "75%" | awk '{ print $3 }'`

>&2 echo "IQ: N = $IQ_N, mean = $IQ_MEAN, median = $IQ_MEDIAN, sd = $IQ_SD, min = $IQ_MIN, max = $IQ_MAX, q1 = $IQ_Q1, q3 = $IQ_Q3"





#echo -n "File Name	N total	N rows	"
#echo -n "Beta_N	Beta_MEAN	Beta_MEDIAN	Beta_SD	Beta_MIN	Beta_MAX	Beta_Q1	Beta_Q3	"
#echo -n "SE_N	SE_MEAN	SE_MEDIAN	SE_SD	SE_MIN	SE_MAX	SE_Q1	SE_Q3	"
#echo -n "PVAL_N	PVAL_MEAN	PVAL_MEDIAN	PVAL_SD	PVAL_MIN	PVAL_MAX	PVAL_Q1	PVAL_Q3	"
#echo -n "AF_coded_all_N	AF_coded_all_MEAN	AF_coded_all_MEDIAN	AF_coded_all_SD	AF_coded_all_MIN	AF_coded_all_MAX	AF_coded_all_Q1	AF_coded_all_Q3	"
#echo "IQ_N	IQ_MEAN	IQ_MEDIAN	IQ_SD	IQ_MIN	IQ_MAX	IQ_Q1	IQ_Q3"

echo -n "$BN	"
echo -n "$NTOTAL	"
echo -n "$NROWS	"

echo -n "$BETA_N	"
echo -n "$BETA_MEAN	"
echo -n "$BETA_MEDIAN	"
echo -n "$BETA_SD	"
echo -n "$BETA_MIN	"
echo -n "$BETA_MAX	"
echo -n "$BETA_Q1	"
echo -n "$BETA_Q3	"

echo -n "$SE_N	"
echo -n "$SE_MEAN	"
echo -n "$SE_MEDIAN	"
echo -n "$SE_SD	"
echo -n "$SE_MIN	"
echo -n "$SE_MAX	"
echo -n "$SE_Q1	"
echo -n "$SE_Q3	"

echo -n "$PVAL_N	"
echo -n "$PVAL_MEAN	"
echo -n "$PVAL_MEDIAN	"
echo -n "$PVAL_SD	"
echo -n "$PVAL_MIN	"
echo -n "$PVAL_MAX	"
echo -n "$PVAL_Q1	"
echo -n "$PVAL_Q3	"

echo -n "$AF_N	"
echo -n "$AF_MEAN	"
echo -n "$AF_MEDIAN	"
echo -n "$AF_SD	"
echo -n "$AF_MIN	"
echo -n "$AF_MAX	"
echo -n "$AF_Q1	"
echo -n "$AF_Q3	"

echo -n "$IQ_N	"
echo -n "$IQ_MEAN	"
echo -n "$IQ_MEDIAN	"
echo -n "$IQ_SD	"
echo -n "$IQ_MIN	"
echo -n "$IQ_MAX	"
echo -n "$IQ_Q1	"
echo -n "$IQ_Q3	"
echo

>&2 echo DONE: $BN


