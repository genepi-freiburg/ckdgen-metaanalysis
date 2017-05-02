SCRIPTS=/shared/metaanalysis/scripts

rm -f 02-locate-input-files.log
rm -f input-files-with-path.txt

cut -f 1 input-file-list.txt > input-file-list-col1.txt

${SCRIPTS}/find-paths.sh input-file-list-col1.txt input-files-with-path.txt | tee -a 02-locate-input-files.log

echo "TOTAL FILE COUNT (without/with paths)" | tee -a 02-locate-input-files.log

wc -l input-file-list.txt input-files-with-path.txt | tee -a 02-locate-input-files.log
