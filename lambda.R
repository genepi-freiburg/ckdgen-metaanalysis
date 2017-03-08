args = commandArgs(trailingOnly=T)
data = read.table(args[1], h=T)
summary(data)

print(paste("row count:", nrow(data)))
print(paste("NA pval:", length(which(is.na(data$pval)))))

chisq <- qchisq(1-data$pval,1)
lambda <- median(chisq)/qchisq(0.5,1)

print(paste("lambda:", lambda))
