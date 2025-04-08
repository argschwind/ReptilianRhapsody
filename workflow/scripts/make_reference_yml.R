## Make input yaml file to generate alignment reference

# save.image("make_yml.rda")
# stop()

# required packages
suppressPackageStartupMessages(
  library(yaml)
)

# make list of main inputs
input <- list(
  Genome_fasta = list(list(class = "File", location = snakemake@input$genome_fasta)),
  Gtf = list(list(class = "File", location = snakemake@input$genome_gtf))
)

# add optional extra sequences
if (!is.null(snakemake@input$extra_sequences)) {
  extra_sequences <- list(
    Extra_sequences = list(list(class = "File", location = snakemake@input$extra_sequences))
  )
  input <- c(input, extra_sequences)
}

# save yaml to file
write_yaml(input, file = snakemake@output[[1]])
