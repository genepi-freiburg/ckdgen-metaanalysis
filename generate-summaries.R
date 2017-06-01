input_files = read.table("input-file-list.txt", h=F)

if (ncol(input_files) == 2) {
	print("detected binary trait")
	colnames(input_files) = c("FILE_NAME", "CASE_COUNT")
	is_binary = T
} else {
	print("detected continuous trait")
	colnames(input_files) = c("FILE_NAME")
	is_binary = F
}
input_files$FILE_NAME = as.character(input_files$FILE_NAME)

input_paths = read.table("input-files-with-path.txt", h=F)
colnames(input_paths) = c("FILE_PATH")
input_paths$FILE_PATH = as.character(input_paths$FILE_PATH)

summary(input_files)
summary(input_paths)

if (nrow(input_paths) != nrow(input_files)) {
	print("ERROR: file names and paths not same size")
	print(nrow(input_paths))
	print(nrow(input_files))
        print((input_paths))
        print((input_files))
	stop()
}

lambdas = read.table("lambdas_input_HQ.txt", h=T)

input = cbind(input_files, input_paths)
summary(input)
print("number of input rows")
nrow(input)

for (i in 1:nrow(input)) {
	fn = input[i, "FILE_PATH"]
	print(paste("process", i, fn))
	segs = unlist(strsplit(fn, "/"))
	parent_dir = paste(segs[1:(length(segs)-2)], collapse='/')
	summary_file = "gwasqc_summaries.txt"
	print(paste("summary file:", summary_file))
	if (!file.exists(summary_file)) {
		print(paste("ERROR: summary file does not exist for study file:", input[i, "FILE_NAME"]))
		stop()
	}

	study = unlist(strsplit(input[i, "FILE_NAME"], "_|[.]"))[1]
	input[i, "STUDY_NAME"] = study
	print(paste("study:", study))

	summaries_table = read.table(summary_file, h=T, sep="\t")
	summary(summaries_table) # will fail if strange things happened

	input[i, "FILE_NAME"] = gsub(".gwas$", ".gwas.gz", input[i, "FILE_NAME"])

	summary_row_idx = which(summaries_table$File.Name == input[i, "FILE_NAME"])
	if (length(summary_row_idx) == 0) {
		print(paste("ERROR: summary file does not have a row for file:", input[i, "FILE_NAME"]))
		print("WARNING - FILE WILL BE SKIPPED - NA PRODUCED")
		next
	}
	print(paste("summary row index:", summary_row_idx))
	summary_row = summaries_table[summary_row_idx,]

	lambda_row_idx = which(lambdas$FILE == input[i, "FILE_NAME"])
	if (length(lambda_row_idx) == 0) {
		print(paste("ERROR: lambda file does not have a row for file:", input[i, "FILE_NAME"]))
		print("WARNING - FILE WILL BE SKIPPED - NA PRODUCED")
		next
	}
	lambda = lambdas[lambda_row_idx, "LAMBDA"]
	print(paste("got lambda:", lambda))

	input[i, "N_TOTAL"] = summary_row["N.total"]
	input[i, "N_ROWS"] = summary_row["N.rows"]
	input[i, "BETA_MEDIAN"] = summary_row["Beta_MEDIAN"]
#	input[i, "BETA_SD"] = summary_row["Beta_SD"]
	input[i, "BETA_Q1"] = summary_row["Beta_Q1"]
	input[i, "BETA_Q3"] = summary_row["Beta_Q3"]
	input[i, "BETA_Skewness"] = summary_row["Beta_Skewness"]
	input[i, "SE_MEDIAN"] = summary_row["SE_MEDIAN"]
#	input[i, "SE_SD"] = summary_row["SE_SD"]
	input[i, "SE_Q1"] = summary_row["SE_Q1"]
	input[i, "SE_Q3"] = summary_row["SE_Q3"]
	input[i, "SE_Skewness"] = summary_row["SE_Skewness"]
	input[i, "PVAL_MIN"] = summary_row["PVAL_MIN"]
	input[i, "PVAL_MEAN"] = summary_row["PVAL_MEAN"]
	input[i, "PVAL_MAX"] = summary_row["PVAL_MAX"]
        input[i, "AF_MEDIAN"] = summary_row["AF_coded_all_MEDIAN"]
        input[i, "AF_MEAN"] = summary_row["AF_coded_all_MEAN"]
        input[i, "AF_SD"] = summary_row["AF_coded_all_SD"]
        input[i, "AF_Q1"] = summary_row["AF_coded_all_Q1"]
        input[i, "AF_Q3"] = summary_row["AF_coded_all_Q3"]
	input[i, "IQ_MEDIAN"] = summary_row["IQ_MEDIAN"]
	input[i, "IQ_MEAN"] = summary_row["IQ_MEAN"]
	input[i, "IQ_SD"] = summary_row["IQ_SD"]
	input[i, "IQ_Q1"] = summary_row["IQ_Q1"]
	input[i, "IQ_Q3"] = summary_row["IQ_Q3"]
	input[i, "LAMBDA_HQ"] = lambda
}

print("SUMMARY OF SUMMARY")
summary(input)
write.table(input, "input-summary.txt", sep="\t", row.names=F, col.names=T, quote=F)

d = subset(input, !is.na(input$N_TOTAL))
pdf("input-summary.pdf",width=14,height=14)
source("/shared/metaanalysis/scripts/boxplot.with.outlier.label.r")

################################
# N
################################
if (is_binary) {
	par(mfrow = c(1, 4), oma=c(0,0,2,0))
} else {
	par(mfrow = c(1, 2), oma=c(0,0,2,0))
}
boxplot.with.outlier.label(d$N_TOTAL, d$STUDY_NAME, spread_text=F)
boxplot.with.outlier.label(d$N_ROWS, d$STUDY_NAME, spread_text=F)
if (is_binary) {
	boxplot.with.outlier.label(d$CASE_COUNT, d$STUDY_NAME, spread_text=F)
	abline(h=100, col="green")
	boxplot.with.outlier.label(d$N_TOTAL-d$CASE_COUNT, d$STUDY_NAME, spread_text=F)
	abline(h=100, col="green")
	title("n(participants), n(variants), n(cases), n(controls)", outer=T, sub="green line: n=100")
} else {
	title("n(participants), n(variants)", outer=T)
}

par(mfrow = c(1, 1), oma=c(0,0,0,0))
plot(d$N_TOTAL, d$N_ROWS, xlab="n(participants)", ylab="n(variants)", pch=21, bg="black")
text(x=d$N_TOTAL, y=d$N_ROWS, labels=d$STUDY_NAME, pos=3, col="blue")
title("n(participants) vs. n(variants)")

################################
# BETA
################################
par(mfrow = c(1, 4), oma=c(0,0,2,0))
boxplot.with.outlier.label(d$BETA_MEDIAN, d$STUDY_NAME, spread_text=F)
#boxplot.with.outlier.label(d$BETA_MEAN, d$STUDY_NAME, spread_text=F)
#boxplot.with.outlier.label(d$BETA_SD, d$STUDY_NAME, spread_text=F)
boxplot.with.outlier.label(d$BETA_Q1, d$STUDY_NAME, spread_text=F)
boxplot.with.outlier.label(d$BETA_Q3, d$STUDY_NAME, spread_text=F)
boxplot.with.outlier.label(d$BETA_Skewness, d$STUDY_NAME, spread_text=F)
title("beta (median/q1/q3/Skewness)", outer=T)

################################
# SE
################################
par(mfrow = c(1, 3), oma=c(0,0,2,0))
boxplot.with.outlier.label(d$SE_MEDIAN, d$STUDY_NAME, spread_text=F)
#boxplot.with.outlier.label(d$SE_MEAN, d$STUDY_NAME, spread_text=F)
#boxplot.with.outlier.label(d$SE_SD, d$STUDY_NAME, spread_text=F)
boxplot.with.outlier.label(d$SE_Q1, d$STUDY_NAME, spread_text=F)
boxplot.with.outlier.label(d$SE_Q3, d$STUDY_NAME, spread_text=F)
#boxplot.with.outlier.label(d$SE_Skewness, d$STUDY_NAME, spread_text=F)
title("SE (median/q1/q3)", outer=T)

################################
# PVAL
################################
par(mfrow = c(1, 3), oma=c(0,0,2,0))
#boxplot.with.outlier.label(d$PVAL_N, d$STUDY_NAME, spread_text=F)
#boxplot.with.outlier.label(d$PVAL_SD, d$STUDY_NAME, spread_text=F)
boxplot.with.outlier.label(d$PVAL_MIN, d$STUDY_NAME, spread_text=F)
boxplot.with.outlier.label(d$PVAL_MEAN, d$STUDY_NAME, spread_text=F)
boxplot.with.outlier.label(d$PVAL_MAX, d$STUDY_NAME, spread_text=F)
title("pvalue (min/mean/max)", outer=T)

################################
# AF
################################
par(mfrow = c(1, 5), oma=c(0,0,2,0))
boxplot.with.outlier.label(d$AF_MEDIAN, d$STUDY_NAME, spread_text=F)
boxplot.with.outlier.label(d$AF_MEAN, d$STUDY_NAME, spread_text=F)
boxplot.with.outlier.label(d$AF_SD, d$STUDY_NAME, spread_text=F)
boxplot.with.outlier.label(d$AF_Q1, d$STUDY_NAME, spread_text=F)
boxplot.with.outlier.label(d$AF_Q3, d$STUDY_NAME, spread_text=F)
title("AF_coded_all (median/mean/sd/q1/q3)", outer=T)

################################
# IQ
################################
par(mfrow = c(1, 5), oma=c(0,0,2,0))
boxplot.with.outlier.label(d$IQ_MEDIAN, d$STUDY_NAME, spread_text=F)
boxplot.with.outlier.label(d$IQ_MEAN, d$STUDY_NAME, spread_text=F)
boxplot.with.outlier.label(d$IQ_SD, d$STUDY_NAME, spread_text=F)
boxplot.with.outlier.label(d$IQ_Q1, d$STUDY_NAME, spread_text=F)
boxplot.with.outlier.label(d$IQ_Q3, d$STUDY_NAME, spread_text=F)
title("IQ (median/mean/sd/q1/q3)", outer=T)

################################
# Lambda
################################
#par(mfrow=c(1, 2))
layout(matrix(c(1,2),1), c(1,6), c(1))
boxplot.with.outlier.label(d$LAMBDA, d$STUDY_NAME, spread_text=F)
#title("Lambda", outer=T)

plot(d$N_TOTAL, d$LAMBDA, xlab="n(participants)", ylab="lambda", bg="black", pch=21)
text(x=d$N_TOTAL, y=d$LAMBDA, labels=d$STUDY_NAME, pos=3, col="blue")
title("n(participants) vs. lambda", outer=T)


# reset
layout(matrix(1,1),c(1),c(1))

tblPlot=data.frame(
	study=d$STUDY_NAME,
	medianSE=d$SE_MEDIAN,
	medianBeta=d$BETA_MEDIAN,
	n_total=d$N_TOTAL)
if (is_binary) {
	tblPlot$Ncases = d$CASE_COUNT
	tblPlot$Nctrls = tblPlot$n_total - tblPlot$Ncases
	tblPlot$lambda = d$LAMBDA
}

tblPlot$medianSE_rez=(1/tblPlot$medianSE)
tblPlot$medianSE_rez2=(tblPlot$medianSE_rez**2)
tblPlot$n_total_sqrt=sqrt(tblPlot$n_total)

################################
# 1/MEDIAN(SE)_SQRT(N)_PLOT
################################
linearModel=lm("medianSE_rez~n_total_sqrt",tblPlot)
intercept=as.numeric(linearModel$coefficients[1])
incline=as.numeric(linearModel$coefficients[2])
par(mar=(c(5,6,6,1)))
plot(x=tblPlot$n_total_sqrt, y=tblPlot$medianSE_rez, xlab="sqrt(n(participants))", ylab="1/median(SE)",
     cex.axis=2, cex=2, cex.lab=2, pch=21, bg="black")
text(x=tblPlot$n_total_sqrt, y=tblPlot$medianSE_rez, labels=tblPlot$study, pos=3)
abline(intercept,incline,col="red",lty=2)

if (is_binary) {
	tblPlot$Neff = 4 / ((1/tblPlot$Ncases)+(1/tblPlot$Nctrls))
	tblPlot$Neff_sqrt = sqrt(tblPlot$Neff)

	linearModel=lm("medianSE_rez~Neff_sqrt",tblPlot)
	intercept=as.numeric(linearModel$coefficients[1])
	incline=as.numeric(linearModel$coefficients[2])
	par(mar=(c(5,6,6,1)))
	plot(x=tblPlot$Neff_sqrt, y=tblPlot$medianSE_rez, xlab="sqrt(Neff); Neff = 4/(1/n(cases) + 1/n(controls))", ylab="1/median(SE)",
             cex.axis=2, cex=2, cex.lab=2, pch=21, bg="black")
        text(x=tblPlot$Neff_sqrt, y=tblPlot$medianSE_rez, labels=tblPlot$study, pos=3)
	abline(intercept, incline, col="red", lty=2)

	plot(tblPlot$Neff, tblPlot$lambda, xlab="Neff = 4/(1/n(cases) + 1/n(controls))", ylab="lambda",
             cex.axis=2, cex=2, cex.lab=2, pch=21, bg="black")
        text(x=tblPlot$Neff, y=tblPlot$lambda, labels=tblPlot$study, pos=3)
        linearModel=lm("lambda~Neff",tblPlot)
        intercept=as.numeric(linearModel$coefficients[1])
        incline=as.numeric(linearModel$coefficients[2])
        abline(intercept, incline, col="red", lty=2)
}


################################
# 1/MEDIAN(SE)_N_PLOT
################################
#linearModel=lm("medianSE_rez~n_total",tblPlot)
#intercept=as.numeric(linearModel$coefficients[1])
#incline=as.numeric(linearModel$coefficients[2])
#par(mar=(c(5,6,6,1)))
#plot(x=tblPlot$n_total, y=tblPlot$medianSE_rez,xlab="Number of Subjects", ylab="1/median(SE)",cex.axis=2,cex=2,cex.lab=2,pch=21,bg="black")
#text(x=tblPlot$n_total, y=tblPlot$medianSE_rez,labels=tblPlot$study,pos=3)
#abline(intercept,incline,col="red",lty=2)

################################
# 1/MEDIAN(SE)^2_N_PLOT
################################
#linearModel=lm("medianSE_rez2~n_total",tblPlot)
#intercept=as.numeric(linearModel$coefficients[1])
#incline=as.numeric(linearModel$coefficients[2])
#par(mar=(c(5,6,6,1)))
#plot(x=tblPlot$n_total, y=tblPlot$medianSE_rez2,xlab="Number of Subjects", ylab="1/(median(SE))^2",cex.axis=2,cex=2,cex.lab=2,pch=21,bg="black")
#text(x=tblPlot$n_total, y=tblPlot$medianSE_rez2,labels=tblPlot$study,pos=3)
#abline(intercept,incline,col="red",lty=2)

################################
# 1/MEDIAN(SE)^2_SQRT(N)_PLOT
################################
#linearModel=lm("medianSE_rez2~n_total_sqrt",tblPlot)
#intercept=as.numeric(linearModel$coefficients[1])
#incline=as.numeric(linearModel$coefficients[2])
#par(mar=(c(5,6,6,1)))
#plot(x=tblPlot$n_total_sqrt, y=tblPlot$medianSE_rez2,xlab="Sqrt(Number of Subjects)", ylab="1/(median(SE))^2",cex.axis=2,cex=2,cex.lab=2,pch=21,bg="black")
#text(x=tblPlot$n_total_sqrt, y=tblPlot$medianSE_rez2,labels=tblPlot$study,pos=3)
#abline(intercept,incline,col="red",lty=2)

################################
# MEDIAN(ABS(BETA))_MEDIAN(SE)_PLOT
################################
#par(mar=(c(5,6,6,1)))
#plot(x=abs(tblPlot$medianBeta), y=tblPlot$medianSE, xlab="abs(median(beta))", ylab="median(SE)", cex.axis=2,cex=2,cex.lab=2,pch=21,bg="black")
#text(x=abs(tblPlot$medianBeta), y=tblPlot$medianSE, labels=tblPlot$study,pos=3)


dev.off()

