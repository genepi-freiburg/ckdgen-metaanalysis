LOG=03-prepare-ma-input.log

echo "LQ" | tee $LOG

/shared/metaanalysis/scripts/prepare-ma-input.sh input-files-with-path.txt 0 0.3 1 100 10 1 input_LQ | tee -a $LOG

echo "HQ" | tee -a $LOG

/shared/metaanalysis/scripts/prepare-ma-input.sh input-files-with-path.txt 0.05 0.6 10 100 10 1 input_HQ | tee -a $LOG
