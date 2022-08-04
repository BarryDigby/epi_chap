#!/usr/bin/Rscript 


args <- commandArgs(trailingOnly=TRUE)

mirna_counts <- as.matrix(read.table(args[1], header=T, sep="\t", row.names=NULL))
mVals <- as.matrix(read.table(args[2], header=T, sep="\t"))

# we have a dup row name, discard it - preserve numeric mat
keep <- !duplicated(mirna_counts[,1])
mirna_counts <- as.matrix(mirna_counts[keep,])
rn <- as.character(mirna_counts[,1])
mirna_counts <- as.matrix(mirna_counts[,-1])
mirna_counts <- apply(mirna_counts, 2, as.numeric)
rownames(mirna_counts) <- rn

# init
tab = matrix(data=NA, nrow=nrow(mVals), ncol = nrow(mirna_counts))
pvaltab = matrix(data=NA, nrow=nrow(mVals), ncol = nrow(mirna_counts))

# ~2 minutes run-time with present data set on a 2016 laptop
# expect warnings for exact p-values and ties
for (i in 1:nrow(mVals)){
  for (j in 1:nrow(mirna_counts)) {
    testres = cor.test(mVals[i, ], mirna_counts[j, ], method="spearman")
    tab[i,j] = testres$estimate
    pvaltab[i,j] = testres$p.value
  }
}

rownames(tab) = rownames(mVals)
colnames(tab) = rownames(mirna_counts)
rownames(pvaltab) = rownames(mVals)
colnames(pvaltab) = rownames(mirna_counts)

write.table(tab, "tab.txt", sep="\t", row.names=T)
write.table(pvaltab, "pvaltab.txt", sep="\t", row.names=T)
