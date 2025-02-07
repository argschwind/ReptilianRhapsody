## Add samples, optional cell numbers and read files per sample to snakemake config object

import pandas as pd

# load samples file
samples_file = pd.read_csv(config["samples_file"], sep="\t", header=None, names=["sample", "cells"],
                           on_bad_lines="skip")

# create simple array of sample ids
samples = list(samples_file["sample"])

# create dictionary with cell numbers per sample (NaN) if not provided
cell_numbers = samples_file.set_index("sample")["cells"].to_dict()

# load reads file
read_files = pd.read_csv(config["reads_file"], sep="\t")

# create a dictionary of lists, containing all read files per sample
read_files = read_files.groupby("sample")["file"].apply(list).to_dict()

# add samples, cell numbers and read files to snakemake config object
config["samples"] = samples
config["cell_numbers"] = cell_numbers
config["read_files"] = read_files
