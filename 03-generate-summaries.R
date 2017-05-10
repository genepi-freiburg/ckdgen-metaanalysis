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

if (nrow(input_paths) != nrow(input_files)) {
	print("ERROR: file names and paths not same size")
	stop()
}

summary(input_files)
summary(input_paths)
input = cbind(input_files, input_paths)
summary(input)
print("number of input rows")
nrow(input)

for (i in 1:nrow(input)) {
	fn = input[i, "FILE_PATH"]
	print(paste("process", i, fn))
	segs = unlist(strsplit(fn, "/"))
	parent_dir = paste(segs[1:(length(segs)-2)], collapse='/')
	summary_file = paste(parent_dir, "11_summaries.txt", sep="/")
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

	summary_row_idx = which(summaries_table$File.Name == input[i, "FILE_NAME"])
	if (length(summary_row_idx) == 0) {
		print(paste("ERROR: summary file does not have a row for file:", input[i, "FILE_NAME"]))
		print("WARNING - FILE WILL BE SKIPPED - NA PRODUCED")
		next
	}
	print(paste("summary row index:", summary_row_idx))
	summary_row = summaries_table[summary_row_idx,]

	input[i, "N_TOTAL"] = summary_row["N.total"]
	input[i, "N_ROWS"] = summary_row["N.rows"]
	input[i, "BETA_MEDIAN"] = summary_row["Beta_MEDIAN"]
#	input[i, "BETA_SD"] = summary_row["Beta_SD"]
	input[i, "BETA_Q1"] = summary_row["Beta_Q1"]
	input[i, "BETA_Q3"] = summary_row["Beta_Q3"]
	input[i, "SE_MEDIAN"] = summary_row["SE_MEDIAN"]
#	input[i, "SE_SD"] = summary_row["SE_SD"]
	input[i, "SE_Q1"] = summary_row["SE_Q1"]
	input[i, "SE_Q3"] = summary_row["SE_Q3"]
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

}

print("SUMMARY OF SUMMARY")
summary(input)
write.table(input, "input-summary.txt", sep="\t", row.names=F, col.names=T, quote=F)

d = subset(input, !is.na(input$N_TOTAL))
pdf("input-summary.pdf",width=14,height=14)

par(mfrow = c(1, 2), oma=c(0,0,2,0))
boxplot(d$N_TOTAL)
boxplot(d$N_ROWS)
title("n(participants), n(variants)", outer=T)

par(mfrow = c(1, 3), oma=c(0,0,2,0))
boxplot(d$BETA_MEDIAN)
#boxplot(d$BETA_MEAN)
#boxplot(d$BETA_SD)
boxplot(d$BETA_Q1)
boxplot(d$BETA_Q3)
title("beta (median/q1/q3)", outer=T)

par(mfrow = c(1, 3), oma=c(0,0,2,0))
boxplot(d$SE_MEDIAN)
#boxplot(d$SE_MEAN)
#boxplot(d$SE_SD)
boxplot(d$SE_Q1)
boxplot(d$SE_Q3)
title("SE (median/q1/q3)", outer=T)

par(mfrow = c(1, 3), oma=c(0,0,2,0))
#boxplot(d$PVAL_N)
#boxplot(d$PVAL_SD)
boxplot(d$PVAL_MIN)
boxplot(d$PVAL_MEAN)
boxplot(d$PVAL_MAX)
title("pvalue (min/mean/max)", outer=T)

par(mfrow = c(1, 5), oma=c(0,0,2,0))
boxplot(d$AF_MEDIAN)
boxplot(d$AF_MEAN)
boxplot(d$AF_SD)
boxplot(d$AF_Q1)
boxplot(d$AF_Q3)
title("AF_coded_all (median/mean/sd/q1/q3)", outer=T)

par(mfrow = c(1, 5), oma=c(0,0,2,0))
boxplot(d$IQ_MEDIAN)
boxplot(d$IQ_MEAN)
boxplot(d$IQ_SD)
boxplot(d$IQ_Q1)
boxplot(d$IQ_Q3)
title("IQ (median/mean/sd/q1/q3)", outer=T)


par(mfrow=c(1,1))
#dev.off()

# MG plots

tblPlot=data.frame(
	study=d$STUDY_NAME,
	medianSE=d$SE_MEDIAN,
	medianBeta=d$BETA_MEDIAN,
	n_total=d$N_TOTAL)

tblPlot$medianSE_rez=(1/tblPlot$medianSE)
tblPlot$medianSE_rez2=(tblPlot$medianSE_rez**2)
tblPlot$n_total_sqrt=sqrt(tblPlot$n_total)
print(tblPlot)

# get coeffcients of the linear model
linearModel=lm("medianSE_rez~n_total_sqrt",tblPlot)
intercept=as.numeric(linearModel$coefficients[1])
incline=as.numeric(linearModel$coefficients[2])

# # finally do the plot
#outfilename="Scatterplot_sqrtN_SE.png"
#png(outfilename,1000,1000)
par(mar=(c(5,6,6,1)))
plot(x=tblPlot$n_total_sqrt, y=tblPlot$medianSE_rez,xlab="Sqrt(Number of Subjects)", ylab="1/median(SE)",cex.axis=2,cex=2,cex.lab=2,pch=21,bg="black")
text(x=tblPlot$n_total_sqrt, y=tblPlot$medianSE_rez,labels=tblPlot$study,pos=3)
abline(intercept,incline,col="red",lty=2)
#dev.off()


# get coeffcients of the linear model
linearModel=lm("medianSE_rez~n_total",tblPlot)
intercept=as.numeric(linearModel$coefficients[1])
incline=as.numeric(linearModel$coefficients[2])


#outfilename="Scatterplot_N_SE.png"
#png(outfilename,1000,1000)
par(mar=(c(5,6,6,1)))
plot(x=tblPlot$n_total, y=tblPlot$medianSE_rez,xlab="Number of Subjects", ylab="1/median(SE)",cex.axis=2,cex=2,cex.lab=2,pch=21,bg="black")
text(x=tblPlot$n_total, y=tblPlot$medianSE_rez,labels=tblPlot$study,pos=3)
abline(intercept,incline,col="red",lty=2)
#dev.off()

# get coeffcients of the linear model
linearModel=lm("medianSE_rez2~n_total",tblPlot)
intercept=as.numeric(linearModel$coefficients[1])
incline=as.numeric(linearModel$coefficients[2])

#outfilename="Scatterplot_N_SE2.png"
#png(outfilename,1000,1000)
par(mar=(c(5,6,6,1)))
plot(x=tblPlot$n_total, y=tblPlot$medianSE_rez2,xlab="Number of Subjects", ylab="1/(median(SE))^2",cex.axis=2,cex=2,cex.lab=2,pch=21,bg="black")
text(x=tblPlot$n_total, y=tblPlot$medianSE_rez2,labels=tblPlot$study,pos=3)
abline(intercept,incline,col="red",lty=2)
#dev.off()



# get coeffcients of the linear model
linearModel=lm("medianSE_rez2~n_total_sqrt",tblPlot)
intercept=as.numeric(linearModel$coefficients[1])
incline=as.numeric(linearModel$coefficients[2])

#outfilename="Scatterplot_sqrtN_SE2.png"
#png(outfilename,1000,1000)
par(mar=(c(5,6,6,1)))
plot(x=tblPlot$n_total_sqrt, y=tblPlot$medianSE_rez2,xlab="Sqrt(Number of Subjects)", ylab="1/(median(SE))^2",cex.axis=2,cex=2,cex.lab=2,pch=21,bg="black")
text(x=tblPlot$n_total_sqrt, y=tblPlot$medianSE_rez2,labels=tblPlot$study,pos=3)
abline(intercept,incline,col="red",lty=2)



par(mar=(c(5,6,6,1)))
plot(x=abs(tblPlot$medianBeta), y=tblPlot$medianSE, xlab="abs(median(beta))", ylab="median(SE)", cex.axis=2,cex=2,cex.lab=2,pch=21,bg="black")
text(x=abs(tblPlot$medianBeta), y=tblPlot$medianSE, labels=tblPlot$study,pos=3)


dev.off()

