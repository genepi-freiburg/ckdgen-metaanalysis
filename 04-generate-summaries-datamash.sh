#!/bin/bash

SCRIPTS=/shared/metaanalysis/scripts
WD=`pwd`
LOG=$WD/04-generate-summaries.log

echo "=============================================="  | tee -a $LOG
echo "Calculate summaries" | tee -a $LOG
echo "==============================================" | tee -a $LOG

$SCRIPTS/calculate-summaries.sh | tee -a $LOG
Rscript $SCRIPTS/generate-summaries.R datamash_summaries.txt | tee -a $LOG

echo "=============================================="  | tee -a $LOG
echo "Calculate Lambdas"  | tee -a $LOG
echo "=============================================="  | tee -a $LOG

$SCRIPTS/make_lambda_table.sh input_HQ lambdas_input_HQ.txt | tee -a $LOG

echo "Done." | tee -a $LOG
