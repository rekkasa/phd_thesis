#!/usr/bin/env Rscript

args = commandArgs(trailingOnly = TRUE)
resultFile <- args[1]
chapter <- args[2]

message(
  paste("Fetching", resultFile, "from github")
)

githubAccount <- "https://github.com/rekkasa"
repo <- "phd_thesis"
repoLocation <- file.path(
  "raw/large-files/data",
  chapter
)

repo <- file.path(githubAccount, repo, repoLocation)

filePath <- file.path(repo, resultFile)

saveDirectory = file.path("data", chapter)

if (!dir.exists(saveDirectory)) {
  dir.create(saveDirectory, recursive = TRUE)
}

saveRDS(
  readRDS(url(filePath)),
  file = file.path(saveDirectory, resultFile)
)

message(
  crayon::green(
    paste(
      "\u2713 File saved at:",
      file.path(file.path(saveDirectory, resultFile)),
      "\n"
    )
  )
)
