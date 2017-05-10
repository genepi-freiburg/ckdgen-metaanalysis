echo "Process file list $1 to output $2"

if [ ! -f "$1" ]
then
	echo "Input file does not exist."
	exit 3
fi

if [ -f "$2" ]
then
	echo "Output file exists - please delete it."
	exit 3
fi

for FN in `cat $1`
do
	echo -n "Find path for $FN: "
	MYPATH=`find /storage/cleaning-finished -type f -name "${FN}*" | grep "combined" | grep "gz$"`
	if [ "$MYPATH" == "" ]
	then
		echo "NOT FOUND in /storage/cleaning-finished => try /shared/cleaning"

		echo "Try under /shared/cleaning"
	        MYPATH=`find /shared/cleaning -type f -name "${FN}*" | grep "combined" | grep "gz$"`
	        if [ "$MYPATH" == "" ]
	        then
        	        echo "NOT FOUND in both locations => FILE MISSING!!"
		else
		        echo $MYPATH
        	        echo $MYPATH >> $2
		fi
	else
		echo $MYPATH
		echo $MYPATH >> $2
	fi
done
