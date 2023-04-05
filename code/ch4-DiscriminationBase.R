#!/usr/bin/env Rscript


args <- commandArgs(trailingOnly = TRUE)
args_base <- as.character(args[1])
args_sampleSize <- as.numeric(args[2])
args_auc <- as.numeric(args[3])
args_value <- as.character(args[4])


library(tidyverse)
library(glue)
library(ggtext)
source("code/ch4-CreateManuscriptPlots.R")
source("code/ch4-PlotResult.R")

scenarioIds <- readr::read_csv("data/simulation/analysisIds.csv") %>%
  filter(
    base == args_base,
    harm != "negative",
    !(type %in% c("quadratic-moderate", "linear-moderate")),
    sampleSize == args_sampleSize,
    auc == args_auc
  )

metric <- "discrimination"

titles <- scenarioIds %>%
  mutate(
    title = ifelse(
      type == "constant",
      str_to_sentence(glue("{str_replace_all(type, '-', ' ')} treatment effect")),
      str_to_sentence(glue("{str_replace_all(type, '-', ' ')} deviation"))
    )
  ) %>%
  select(title) %>%
  unlist() %>%
  unique()

names(titles) <- NULL
titlePrefix <- paste0(LETTERS[1:5], ")")


titles <- paste(
  titlePrefix,
  titles
)


metricFile <- paste(metric, "csv", sep = ".")

processed <- readr::read_csv(
  file = file.path("data/simulation", metricFile)
)
scenarios <- scenarioIds %>%
  filter(harm == "absent") %>%
  select(scenario) %>%
  unlist()
names(scenarios) <- NULL

plotList <- plotResult(scenarios, processed, titles, metric = metric, limits = c(.49, .6, .01))

res <- gridExtra::grid.arrange(
  plotList[[1]] +
    theme(
      plot.title = element_text(),
      axis.title = element_blank(),
      legend.direction = "horizontal",
      legend.position = c(.489, .898),
      legend.title = element_text(size = 8.3),
      legend.text = element_text(size = 7.8),
      legend.box.background = ggplot2::element_blank(),
      legend.background = ggplot2::element_rect(fill = "#F0F2F3"),
      panel.grid.minor = element_blank()
      # axis.text.x = element_blank()
    ),
  plotList[[2]] +
    theme(
      plot.title = element_text(),
      axis.title = element_blank(),
      legend.position = "none",
      panel.grid.minor = element_blank()
      # axis.text.x = element_blank()
    ),
  plotList[[3]] +
    theme(
      plot.title = element_text(),
      axis.title = element_blank(),
      panel.grid.minor = element_blank(),
      legend.position = "none"
    ),
  plotList[[4]] +
    theme(
      plot.title = element_text(),
      axis.title = element_blank(),
      panel.grid.minor = element_blank(),
      legend.position = "none"
    ),
  heights = c(1, 1.05),
  nrow = 2,
  ncol = 2,
  left = "C-statistic for benefit",
  bottom = grid::textGrob(
    "Method",
    just = "center",
    gp = grid::gpar(fontsize = 12)
  )
)

fileName <- paste0(
  "ch4-",
  paste(
    metric,
    args_base,
    args_value,
    sep = "_"
  ),
  ".tiff"
)
ggsave(
  file.path("figures", fileName),
  res,
  height = 6.5,
  width = 8,
  dpi = 1000,
  compression = "lzw+p",
  bg = "#F1F3F8"
)
