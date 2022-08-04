#!/usr/bin/env nextflow


ch_mirna_cts = Channel.fromPath("/data2/bdigby/epigenetics_rdats/mirna_counts.txt")
ch_m_vals = Channel.fromPath("/data2/bdigby/epigenetics_rdats/mVals.txt")
params.outdir = "/data2/bdigby/epigenetics_rdats"


process CORR{

    publishDir "${params.outdir}/results", mode:'copy'

    input:
    file(mirs) from ch_mirna_cts
    file(mvals) from ch_m_vals

    output:
    file("tab.txt") into ch_tab,ch_tab2,ch_tab3
    file("pvaltab.txt") into ch_pval

    script:
    """
    Rscript /data2/bdigby/epigenetics_rdats/corr.R $mirs $mvals
    """
}

process SPLIT_PVAL{
    publishDir "${params.outdir}/results", mode: 'copy'

    input:
    file(pval) from ch_pval

    output:
    file("*.txt") into ch_pval_splits

    script:
    """
    Rscript /data2/bdigby/epigenetics_rdats/split_pval.R
    """
}

a = ch_pval_splits.flatten().map{ it -> [it.simpleName, it]}.view()

process SPLIT_TAB{
    publishDir "${params.outdir}/results", mode: 'copy'

    input:
    file(tab) from ch_tab

    output:
    file("*.txt") into ch_tab_splits

    script:
    """
    Rscript /data2/bdigby/epigenetics_rdats/split_tab.R
    """
}

b = ch_tab_splits.flatten().map{ it -> [it.simpleName, it]}
c = a.join(b)

process SIG_TAB{
    publishDir "${params.outdir}/results", mode:'copy'

    input:
    tuple val(base), file(pval), file(tab) from c

    output:
    file("*.txt") into ch_splits

    script:
    """
    Rscript /data2/bdigby/epigenetics_rdats/bonferroni.R $pval $tab
    """
}

process COMB{
    publishDir "${params.outdir}/results", mode:'copy'

    input:
    file(splits) from ch_splits.collect()

    output:
    file("sig.tab.txt") into ch_sig_tab_row,ch_sig_tab_col

    script:
    """
    cat *.txt > tmp
    grep -v "miRNA" tmp > sig.tab.txt.tmp
    echo -e "CpG\tmiRNA\tSpearman_pval\tSpearman_cor" | cat - sig.tab.txt.tmp > sig.tab.txt
    rm sig.tab.txt.tmp
    rm tmp
    """
}

process DIST_ROW{
    publishDir "${params.outdir}/results", mode:'copy'
    memory '123 GB'

    input:
    file(sig) from ch_sig_tab_row
    file(tab) from ch_tab2

    output:
    file("*RData") into ch_dist_row

    script:
    """
    Rscript /data2/bdigby/epigenetics_rdats/dist_row.R $sig $tab
    """
}

process HCLST_ROW{
   publishDir "${params.outdir}/results", mode:'copy'
   memory '123 GB'

   input:
   file(dist) from ch_dist_row

   output:
   file("*RData") into out

   script:
   """
   Rscript /data2/bdigby/epigenetics_rdats/hclust_row.R
   """
}

process DIST_COL{
    publishDir "${params.outdir}/results", mode:'copy'
    memory '123 GB'

    input:
    file(sig) from ch_sig_tab_col
    file(tab) from ch_tab3

    output:
    file("*RData") into ch_dist_col

    script:
    """
    Rscript /data2/bdigby/epigenetics_rdats/dist_col.R $sig $tab
    """
}

process HCLST_COL{
   publishDir "${params.outdir}/results", mode:'copy'
   memory '123 GB'

   input:
   file(dist) from ch_dist_col

   output:
   file("*RData") into out2

   script:
   """
   Rscript /data2/bdigby/epigenetics_rdats/hclust_col.R
   """
}

