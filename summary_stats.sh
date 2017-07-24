zcat input_HQ/DECODE_EA_eGFR_overall_13062017_chr1-22.gwas.gz | \
	 /shared/metaanalysis/bin/datamash/datamash-1.1.0/datamash -W -H median 6-14 min 6-14 max 6-14 q1 6-14 q3 6-14 mean 6-14 sstdev 6-14 ^C


#File Name       N total N rows  Beta_N  Beta_MEAN       Beta_MEDIAN     Beta_SD Beta_MIN        Beta_MAX        Beta_Q1 Beta_Q3 Beta_Skewness   SE_N    SE_MEAN SE_MEDIAN       SE_SD   SE_MIN  SE_MAX  SE_Q1   SE_Q3   SE_Skewness     PVAL_N  PVAL_MEAN       PVAL_MEDIAN     PVAL_SD PVAL_MIN        PVAL_MAX        PVAL_Q1 PVAL_Q3 AF_coded_all_N  AF_coded_all_MEAN       AF_coded_all_MEDIAN     AF_coded_all_SD AF_coded_all_MIN        AF_coded_all_MAX        AF_coded_all_Q1 AF_coded_all_Q3 IQ_N    IQ_MEAN IQ_MEDIAN       IQ_SD   IQ_MIN  IQ_MAX  IQ_Q1   IQ_Q3


