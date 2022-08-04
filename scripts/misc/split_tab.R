#!/usr/bin/Rscript

set.seed(123)

tab <- read.table("tab.txt", header=T, row.names=1, sep="\t")

# split into 16 files for paralellization

df <- split.data.frame(tab, sample(rep(1:16, nrow(tab)/16)))

# store as var
df1 = df$`1`
df2 = df$`2`
df3 = df$`3`
df4 = df$`4`
df5 = df$`5`
df6 = df$`6`
df7 = df$`7`
df8 = df$`8`
df9 = df$`9`
df10 = df$`10`
df11 = df$`11`
df12 = df$`12`
df13 = df$`13`
df14 = df$`14`
df15 = df$`15`
df16 = df$`16`

# write

write.table(df1, "df1.tab.txt", row.names=T, sep="\t", quote=F)
write.table(df2, "df2.tab.txt", row.names=T, sep="\t", quote=F)
write.table(df3, "df3.tab.txt", row.names=T, sep="\t", quote=F)
write.table(df4, "df4.tab.txt", row.names=T, sep="\t", quote=F)
write.table(df5, "df5.tab.txt", row.names=T, sep="\t", quote=F)
write.table(df6, "df6.tab.txt", row.names=T, sep="\t", quote=F)
write.table(df7, "df7.tab.txt", row.names=T, sep="\t", quote=F)
write.table(df8, "df8.tab.txt", row.names=T, sep="\t", quote=F)
write.table(df9, "df9.tab.txt", row.names=T, sep="\t", quote=F)
write.table(df10, "df10.tab.txt", row.names=T, sep="\t", quote=F)
write.table(df11, "df11.tab.txt", row.names=T, sep="\t", quote=F)
write.table(df12, "df12.tab.txt", row.names=T, sep="\t", quote=F)
write.table(df13, "df13.tab.txt", row.names=T, sep="\t", quote=F)
write.table(df14, "df14.tab.txt", row.names=T, sep="\t", quote=F)
write.table(df15, "df15.tab.txt", row.names=T, sep="\t", quote=F)
write.table(df16, "df16.tab.txt", row.names=T, sep="\t", quote=F)
