args = commandArgs(trailingOnly = TRUE)

d = read.table(args[1], h=F, fill=T)
colnames(d) = c("FN", 
		"CHR01_COUNT", "CHR01_LABEL",
		"CHR02_COUNT", "CHR02_LABEL",
		"CHR03_COUNT", "CHR03_LABEL",
		"CHR04_COUNT", "CHR04_LABEL",
		"CHR05_COUNT", "CHR05_LABEL",
		"CHR06_COUNT", "CHR06_LABEL",
		"CHR07_COUNT", "CHR07_LABEL",
		"CHR08_COUNT", "CHR08_LABEL",
		"CHR09_COUNT", "CHR09_LABEL",
		"CHR10_COUNT", "CHR10_LABEL",
		"CHR11_COUNT", "CHR11_LABEL",
		"CHR12_COUNT", "CHR12_LABEL",
		"CHR13_COUNT", "CHR13_LABEL",
		"CHR14_COUNT", "CHR14_LABEL",
		"CHR15_COUNT", "CHR15_LABEL",
		"CHR16_COUNT", "CHR16_LABEL",
		"CHR17_COUNT", "CHR17_LABEL",
		"CHR18_COUNT", "CHR18_LABEL",
		"CHR19_COUNT", "CHR19_LABEL",
		"CHR20_COUNT", "CHR20_LABEL",
		"CHR21_COUNT", "CHR21_LABEL",
		"CHR22_COUNT", "CHR22_LABEL"
		)

d$N_SNP = d$CHR01_COUNT +
	d$CHR02_COUNT +
	d$CHR03_COUNT +
	d$CHR04_COUNT +
	d$CHR05_COUNT +
	d$CHR06_COUNT +
	d$CHR07_COUNT +
	d$CHR08_COUNT +
	d$CHR09_COUNT +
	d$CHR10_COUNT +
	d$CHR11_COUNT +
	d$CHR12_COUNT +
	d$CHR13_COUNT +
	d$CHR14_COUNT +
	d$CHR15_COUNT +
	d$CHR16_COUNT +
	d$CHR17_COUNT +
	d$CHR18_COUNT +
	d$CHR19_COUNT +
	d$CHR20_COUNT +
	d$CHR21_COUNT +
	d$CHR22_COUNT;


for (i in seq(1,22)) {
	if (i < 10) {
		name = paste("CHR0", i, sep="")
	} else {
		name = paste("CHR", i, sep="")
	}
	name_rel = paste(name, "_REL", sep="")
	name_abs = paste(name, "_COUNT", sep="")
	print(paste(name_rel, name_abs))
	d[,name_rel] = d[,name_abs] / d$N_SNP
}

summary(d)

# rows = study, columns = name_rels

x = t(data.matrix(data.frame(d$CHR01_REL,
	d$CHR02_REL,
	d$CHR03_REL,
	d$CHR04_REL,
	d$CHR05_REL,
	d$CHR06_REL,
	d$CHR07_REL,
	d$CHR08_REL,
	d$CHR09_REL,
	d$CHR10_REL,
	d$CHR11_REL,
	d$CHR12_REL,
	d$CHR13_REL,
	d$CHR14_REL,
	d$CHR15_REL,
	d$CHR16_REL,
	d$CHR17_REL,
	d$CHR18_REL,
	d$CHR19_REL,
	d$CHR20_REL,
	d$CHR21_REL,
	d$CHR22_REL
	)))
colnames(x) = substr(d$FN, 1, 30)

png("variant-count-plot.png", width=10000, height=700)
par(las=2)
par(mar=c(20,4,4,1))

barplot(x, main="Relative variant count per chromosome and study",
  xlab="", col=rainbow(22), ylab="Fraction (nSnpsPerChr/nSnps)",
 	legend = paste("chr", seq(1,22)))
dev.off()

write.table(d, "variant-counts-table.txt", row.names=F, col.names=T, quote=F)
