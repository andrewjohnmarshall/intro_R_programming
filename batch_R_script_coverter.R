
# Batch converter to save .Rmd files as .R scripts
# Andy Marshall
# 2026-04-08

# Searches root directory for R project folders
# and converts every .Rmd file in each folder to
# an .R script with the same name in the same folder.
# Based on knitr::purl()

library(knitr)

# define repo root
root <- 'intro_R_programming'  

# pull list of all .rmd files
rmd_files <- list.files(
  path = root,
  pattern = "\\.Rmd$",
  recursive = TRUE,
  full.names = TRUE
)

# break if no .Rmd files
stopifnot(length(rmd_files) > 0)

# batch convert .Rmd files
for (rmd in rmd_files) {
  out_r <- sub("\\.Rmd$", ".R", rmd)
  knitr::purl(
    input = rmd,
    output = out_r,
    documentation = 2 
  )
}