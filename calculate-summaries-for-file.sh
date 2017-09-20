BN=$1
FN=input_HQ/$BN
if [ "$BN" == "" ]
then
	echo "Input basename missing"
	exit 3
fi

if [ ! -f "$FN" ]
then
	echo "Input file missing: $FN"
	exit 3
fi

function findColValue {
	COLNAME=$1
	cat datamash.txt | awk -v fn="$COLNAME" '{ 
		if (NR==1) {
			for (i = 1; i <= NF; i++) {
			        if ($i == fn) {
			            cidx = i;
			        }
			}
		} else { 
			print $cidx 
		}
	}'
}

FIND_COL="/shared/cleaning/scripts/find-column-index.pl"
NTOTAL_COL=$((`$FIND_COL n_total $FN`+1))
BETA_COL=$((`$FIND_COL beta $FN`+1))
SE_COL=$((`$FIND_COL SE $FN`+1))
PVAL_COL=$((`$FIND_COL pval $FN`+1))
AF_COL=$((`$FIND_COL AF_coded_all $FN`+1))
IQ_COL=$((`$FIND_COL oevar_imp $FN`+1))

>&2 echo "COLUMN INDICES"
>&2 echo "beta column: $BETA_COL"
>&2 echo "SE column: $SE_COL"
>&2 echo "pval column: $PVAL_COL"
>&2 echo "AF column: $AF_COL"
>&2 echo "IQ column: $IQ_COL"

>&2 echo
>&2 echo "INVOKE DATAMASH"
zcat $FN | datamash --headers -W \
	count $NTOTAL_COL  \
	median $NTOTAL_COL \
			   \
	count $BETA_COL    \
	mean $BETA_COL 	   \
	median $BETA_COL   \
	sstdev $BETA_COL   \
	min $BETA_COL      \
	max $BETA_COL      \
	q1 $BETA_COL       \
	q3 $BETA_COL       \
	sskew $BETA_COL    \
			   \
        count $SE_COL      \
        mean $SE_COL       \
        median $SE_COL     \
        sstdev $SE_COL     \
        min $SE_COL        \
        max $SE_COL        \
        q1 $SE_COL         \
        q3 $SE_COL         \
        sskew $SE_COL      \
			   \
        count $PVAL_COL    \
        mean $PVAL_COL     \
        median $PVAL_COL   \
        sstdev $PVAL_COL   \
        min $PVAL_COL      \
        max $PVAL_COL      \
        q1 $PVAL_COL       \
        q3 $PVAL_COL       \
        sskew $PVAL_COL    \
                           \
        count $AF_COL      \
        mean $AF_COL       \
        median $AF_COL     \
        sstdev $AF_COL     \
        min $AF_COL        \
        max $AF_COL        \
        q1 $AF_COL         \
        q3 $AF_COL         \
			   \
        count $IQ_COL      \
        mean $IQ_COL       \
        median $IQ_COL     \
        sstdev $IQ_COL     \
        min $IQ_COL        \
        max $IQ_COL        \
        q1 $IQ_COL         \
        q3 $IQ_COL         \
	> datamash.txt
	
	
>&2 echo "EXTRACT DATA"
NROWS=`findColValue "count(n_total)"`
NTOTAL=`findColValue "median(n_total)"`
>&2 echo "Sample Size: n(rows) = $NROWS, n(total) = $NTOTAL"

BETA_N=`findColValue "count(beta)"`
BETA_MEAN=`findColValue "mean(beta)"`
BETA_MEDIAN=`findColValue "median(beta)"`
BETA_SD=`findColValue "sstdev(beta)"`
BETA_MIN=`findColValue "min(beta)"`
BETA_MAX=`findColValue "max(beta)"`
BETA_Q1=`findColValue "q1(beta)"`
BETA_Q3=`findColValue "q3(beta)"`
BETA_SKEW=`findColValue "sskew(beta)"`

>&2 echo "Beta: N = $BETA_N, mean = $BETA_MEAN, median = $BETA_MEDIAN, sd = $BETA_SD, min = $BETA_MIN, max = $BETA_MAX, q1 = $BETA_Q1, q3 = $BETA_Q3, Skewness = $BETA_SKEW"

SE_N=`findColValue "count(SE)"`
SE_MEAN=`findColValue "mean(SE)"`
SE_MEDIAN=`findColValue "median(SE)"`
SE_SD=`findColValue "sstdev(SE)"`
SE_MIN=`findColValue "min(SE)"`
SE_MAX=`findColValue "max(SE)"`
SE_Q1=`findColValue "q1(SE)"`
SE_Q3=`findColValue "q3(SE)"`
SE_SKEW=`findColValue "sskew(SE)"`

>&2 echo "SE: N = $SE_N, mean = $SE_MEAN, median = $SE_MEDIAN, sd = $SE_SD, min = $SE_MIN, max = $SE_MAX, q1 = $SE_Q1, q3 = $SE_Q3, Skewness = $SE_SKEW"

PVAL_N=`findColValue "count(pval)"`
PVAL_MEAN=`findColValue "mean(pval)"`
PVAL_MEDIAN=`findColValue "median(pval)"`
PVAL_SD=`findColValue "sstdev(pval)"`
PVAL_MIN=`findColValue "min(pval)"`
PVAL_MAX=`findColValue "max(pval)"`
PVAL_Q1=`findColValue "q1(pval)"`
PVAL_Q3=`findColValue "q3(pval)"`

>&2 echo "PVAL: N = $PVAL_N, mean = $PVAL_MEAN, median = $PVAL_MEDIAN, sd = $PVAL_SD, min = $PVAL_MIN, max = $PVAL_MAX, q1 = $PVAL_Q1, q3 = $PVAL_Q3"

AF_N=`findColValue "count(AF_coded_all)"`
AF_MEAN=`findColValue "mean(AF_coded_all)"`
AF_MEDIAN=`findColValue "median(AF_coded_all)"`
AF_SD=`findColValue "sstdev(AF_coded_all)"`
AF_MIN=`findColValue "min(AF_coded_all)"`
AF_MAX=`findColValue "max(AF_coded_all)"`
AF_Q1=`findColValue "q1(AF_coded_all)"`
AF_Q3=`findColValue "q3(AF_coded_all)"`

>&2 echo "AF_coded_all: N = $AF_N, mean = $AF_MEAN, median = $AF_MEDIAN, sd = $AF_SD, min = $AF_MIN, max = $AF_MAX, q1 = $AF_Q1, q3 = $AF_Q3"

IQ_N=`findColValue "count(oevar_imp)"`
IQ_MEAN=`findColValue "mean(oevar_imp)"`
IQ_MEDIAN=`findColValue "median(oevar_imp)"`
IQ_SD=`findColValue "sstdev(oevar_imp)"`
IQ_MIN=`findColValue "min(oevar_imp)"`
IQ_MAX=`findColValue "max(oevar_imp)"`
IQ_Q1=`findColValue "q1(oevar_imp)"`
IQ_Q3=`findColValue "q3(oevar_imp)"`

>&2 echo "IQ: N = $IQ_N, mean = $IQ_MEAN, median = $IQ_MEDIAN, sd = $IQ_SD, min = $IQ_MIN, max = $IQ_MAX, q1 = $IQ_Q1, q3 = $IQ_Q3"

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
echo -n "$BETA_SKEW	"

echo -n "$SE_N	"
echo -n "$SE_MEAN	"
echo -n "$SE_MEDIAN	"
echo -n "$SE_SD	"
echo -n "$SE_MIN	"
echo -n "$SE_MAX	"
echo -n "$SE_Q1	"
echo -n "$SE_Q3	"
echo -n "$SE_SKEW	"

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
echo -n "$IQ_Q3"
echo

>&2 echo DONE: $BN


rm -f datamash.txt
