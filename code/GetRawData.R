#!/usr/bin/env Rscript

args = commandArgs(trailingOnly = TRUE)
resultsLocation <- args[1]

message(
  paste("Fetching", resultsLocation, "from github")
)

githubAccount <- "https://github.com/rekkasa"
repo <- "phd_thesis"
repoLocation <- file.path(
  "raw/large-files",
  resultsLocation
)

repo <- file.path(githubAccount, repo, repoLocation)

if (!dir.exists(dirname(resultsLocation))) {
  dir.create(dirname(resultsLocation), recursive = TRUE)
}

saveRDS(
  readRDS(url(repo)),
  file = resultsLocation
)

message(
  crayon::green(
    paste(
      "\u2713 File saved at:",
      resultsLocation,
      "\n"
    )
  )
)
