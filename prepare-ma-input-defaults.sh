if [ "$1" == "" ]
then
	echo "Usage: $0 <INPUT_FILE_LIST.txt>"
	exit 3
fi

/shared/metaanalysis/scripts/prepare-ma-input.sh $1 0.001 0.3 5 100 2 1

