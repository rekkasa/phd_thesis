#!/usr/bin/env Rscript

args = commandArgs(trailingOnly = TRUE)
resultFile <- args[1]
chapter <- args[2]
prefix <- args[3]

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

if (!is.na(prefix)) {
  filePath <- file.path(
    repo,
    prefix,
    resultFile
  )
} else {
  filePath <- file.path(repo, resultFile)
}

saveDirectory = file.path("data", chapter)
if (!is.na(prefix)) {
  saveDirectory <- file.path(saveDirectory, prefix)
}

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
