#!/usr/bin/Rscript

args <- commandArgs(trailingOnly=TRUE)

sig.tab <- read.table(args[1], header=T, sep="\t", row.names=NULL)
sig.tab <- sig.tab[,-c(1)]

tab <- read.table(args[2], header=T, sep="\t")
colnames(tab) = gsub("\\.", "-", colnames(tab))
sig_mirs <- unique(sig.tab$miRNA)
sig_cpgs <- unique(sig.tab$CpG)
tab <- tab[,sig_mirs]
tab <- tab[sig_cpgs,]

d <- as.dist(1 - cor(t(tab)))

rm(sig_mirs, sig_cpgs, tab, sig.tab)

save.image("dist_row.RData")
