#!/bin/bash

SCRIPTS=/shared/metaanalysis/scripts
WD=`pwd`

rm -rf gwasqc
mkdir gwasqc
cd gwasqc
cp $SCRIPTS/gwasqc.R .
cp $SCRIPTS/gwasqc-params-template.txt gwasqc-params.txt

echo "=============================================="
echo "Prepare GWASQC input files"
echo "=============================================="

for FN in `ls -1 ../input/*.gwas.gz`
do
	BN=`basename $FN`
	echo "PROCESS $BN" >> gwasqc-params.txt
	ln -s ../input/$FN $BN
done
ls -l

echo "=============================================="
echo "Run GWASQC"
echo "=============================================="

Rscript gwasqc.R
rm *.gwas.gz
cd $WD

echo "=============================================="
echo "Collect summaries"
echo "=============================================="

$SCRIPTS/collect-summaries.sh
Rscript $SCRIPTS/generate-summaries.R

echo "Done."
