#!/usr/bin/env nextflow

Channel
    .fromFilePairs('./reads/*_R{1,2}.fastq.gz')
    .set { samples_ch }

process namereads {
    publishDir "./temp/"
    input:
    set sampleId, file(reads) from samples_ch

    output:
    file '*.txt' into temp_ch

    """
    echo --sample $sampleId --reads $reads > ${sampleId}.txt
    """
}


process gathernames {
    publishDir "./results/"
    input:
    file '*.txt' from temp_ch.collect()

    output:
    file 'allnames'

    """
    cat *.txt > allnames
    """
}
