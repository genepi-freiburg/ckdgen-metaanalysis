#!/bin/bash

LOG=04-generate-summaries.log
SCRIPTS=/shared/metaanalysis/scripts
WD=`pwd`

rm -rf gwasqc
mkdir gwasqc
cd gwasqc
cp $SCRIPTS/gwasqc.R .
cp $SCRIPTS/gwasqc-params-template.txt gwasqc-params.txt

echo "==============================================" | tee $LOG
echo "Prepare GWASQC input files" | tee -a $LOG
echo "==============================================" | tee -a $LOG

for FN in `ls -1 ../input_HQ/*.gwas.gz`
do
	BN=`basename $FN`
	echo "PROCESS $BN" >> gwasqc-params.txt
	ln -s ../input_HQ/$FN $BN
done
ls -l

echo "=============================================="  | tee -a $LOG
echo "Run GWASQC" | tee -a $LOG
echo "==============================================" | tee -a $LOG

Rscript gwasqc.R | tee -a $LOG
rm *.gwas.gz
cd $WD

echo "=============================================="  | tee -a $LOG
echo "Calculate Lambdas"  | tee -a $LOG
echo "=============================================="  | tee -a $LOG

$SCRIPTS/make_lambda_table.sh input_HQ lambdas_input_HQ.txt | tee -a $LOG

echo "=============================================="  | tee -a $LOG
echo "Collect summaries" | tee -a $LOG
echo "==============================================" | tee -a $LOG

$SCRIPTS/collect-summaries.sh | tee -a $LOG
Rscript $SCRIPTS/generate-summaries.R | tee -a $LOG

echo "Done." | tee -a $LOG
