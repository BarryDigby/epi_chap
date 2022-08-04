#!/usr/bin/Rscript

load("dist_col.RData")

hc <- hclust(d, method="average")
rm(d)

save.image("hclust_col.RData")
