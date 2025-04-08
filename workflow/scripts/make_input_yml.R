## Create yaml file containing all inputs for the BD Rhapsody pipeline for one sample

# required packages
suppressPackageStartupMessages(
  library(yaml)
)

# function to create entry for one reads file
make_reads_entry <- function(reads_file) {
  list(
    class = "File",
    location = reads_file
  ) 
}

# create list for all input reads files for the given sample
read_files <- list(
  Reads = lapply(snakemake@input$reads, FUN = make_reads_entry)
)

# create list for reference
reference <- list(
  Reference_Archive = list(
    class = "File",
    location = snakemake@input$reference
  )
)

# create entry for optional cell numbers if provided
if (!is.na(snakemake@params$cell_numbers)) {
  cells <- list(
    Expected_Cell_Count = as.integer(snakemake@params$cell_numbers)
  )
} else {
  cells <- NULL
}

# create list for other pipeline arguments
arguments <- list(
  Generate_Bam = verbatim_logical(snakemake@params$generate_bam),
  Maximum_Threads = as.integer(snakemake@params$threads)
)

# combine into list specifying all inputs and arguments
all_input <- c(
  "cwl:tool" = "rhapsody",
  read_files,
  reference,
  cells,
  arguments
)

# conver to yamls string without trailing newline character
input_yaml <- sub("\n$", "", as.yaml(all_input))

# write to output yaml file
write("#!/usr/bin/env cwl-runner", file = snakemake@output[[1]])
write(input_yaml, file = snakemake@output[[1]], append = TRUE)
