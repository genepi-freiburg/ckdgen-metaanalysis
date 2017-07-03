LOG=03-prepare-ma-input.log

# 'secret' param that may be set to skip existing output files
# this speeds up the process if you resume a previous run
# WARNING: take care not to keep partial files
SKIP_EXIST="$1"

echo "LQ" | tee $LOG

/shared/metaanalysis/scripts/prepare-ma-input.sh input-files-with-path.txt 0 0.3 1 100 10 1 input_LQ $SKIP_EXIST | tee -a $LOG

echo "HQ" | tee -a $LOG

/shared/metaanalysis/scripts/prepare-ma-input.sh input-files-with-path.txt 0.05 0.6 10 100 10 1 input_HQ $SKIP_EXIST | tee -a $LOG
