#!/usr/bin/Rscript

load("dist_row.RData")

hr <- hclust(d, method="average")
rm(d)

save.image("hclust_row.RData")
