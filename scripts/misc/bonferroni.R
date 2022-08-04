#!/usr/bin/Rscript

args <- commandArgs(trailingOnly=TRUE)

pvaltab <- read.table(args[1], header=T, row.names=1, sep="\t")
tab <- read.table(args[2], header=T, row.names=1, sep="\t")
string <- as.character(args[1])

denom = 0.05/(107696*256)

sig.tab = c()
for (i in 1:nrow(pvaltab)) {
  for (j in 1:ncol(pvaltab)) {
    if (pvaltab[i,j] < denom) {
      sig.tab = append(sig.tab,
             list(data.frame(
                CpG=rownames(pvaltab)[i],
                miRNA=colnames(pvaltab)[j],
                Spearman_pval=pvaltab[i,j],
                Spearman_cor=tab[i,j])))
    }
  }
}

sig.tab <- do.call(rbind, sig.tab)
sig.tab <- as.data.frame(sig.tab)
sig.tab$miRNA <- gsub("\\.", "-", sig.tab$miRNA)

string <- gsub("txt", "", string)
fn = paste0(string, "sig.tab.txt", sep="")
write.table(sig.tab, paste0(fn), row.names=T, sep="\t")
