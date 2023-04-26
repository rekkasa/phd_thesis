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

metric    <- "calibration"

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

f <- function(x) x * 100

processed <- readr::read_csv(
  file = file.path("data/simulation", metricFile)
) %>%
  mutate_at(
    c(
      "constant_treatment_effect",
      "stratified",
      "linear_predictor",
      "rcs_3_knots",
      "rcs_4_knots",
      "rcs_5_knots",
      "adaptive"
    ),
    f
  )
scenarios <- scenarioIds %>%
  filter(harm == "absent") %>%
  select(scenario) %>%
  unlist()
names(scenarios) <- NULL

plotList <- plotResult(scenarios, processed, titles, metric = metric, limits = c(0, 6, 1))

# res <- gridExtra::grid.arrange(
#   plotList[[1]] +
#     theme(
#       plot.title = element_text(),
#       axis.title = element_blank(),
#       legend.direction = "horizontal",
#       legend.position = c(.473, .898),
#       legend.title = element_text(size = 10.3),
#       legend.text = element_text(size = 9.8),
#       legend.box.background = ggplot2::element_blank(),
#       legend.background = ggplot2::element_rect(fill = "#F0F2F3"),
#       panel.grid.minor = element_blank()
#       # axis.text.x = element_blank()
#     ),
#   plotList[[2]] +
#     theme(
#       plot.title = element_text(),
#       axis.title = element_blank(),
#       legend.position = "none",
#       panel.grid.minor = element_blank()
#       # axis.text.x = element_blank()
#     ),
#   plotList[[3]] +
#     theme(
#       plot.title = element_text(),
#       axis.title = element_blank(),
#       panel.grid.minor = element_blank(),
#       legend.position = "none"
#     ),
#   plotList[[4]] +
#     theme(
#       plot.title = element_text(),
#       axis.title = element_blank(),
#       panel.grid.minor = element_blank(),
#       legend.position = "none"
#     ),
#   heights = c(1, 1.05),
#   nrow = 2,
#   ncol = 2,
#   left = grid::textGrob(
#     expression(
#       paste(
#         "Calibration for benefit (x",
#         10^-2,
#         ")"
#       )
#     ),
#     rot = 90
#   ),
#   bottom = grid::textGrob(
#     "Method",
#     just = "center",
#     gp = grid::gpar(fontsize = 10)
#   )
# )

fileName <- paste0(
  "ch4-",
  paste(
    metric,
    args_base,
    args_value,
    sep = "_"
  ),
  ".pdf"
)

pdf(file.path("figures", fileName), width = 9.8, height = 6.8, bg = "#F1F3F8") # Open a new pdf file
gridExtra::grid.arrange(
  plotList[[1]] +
    theme(
      plot.title = element_text(),
      axis.title = element_blank(),
      axis.text = ggplot2::element_text(size = 11),
      legend.direction = "horizontal",
      legend.position = c(.484, .898),
      legend.title = element_text(size = 11),
      legend.text = element_text(size = 11),
      legend.box.background = ggplot2::element_blank(),
      legend.background = ggplot2::element_rect(fill = "#F0F2F3"),
      panel.grid.minor = element_blank()
      # axis.text.x = element_blank()
    ),
  plotList[[2]] +
    theme(
      axis.text = ggplot2::element_text(size = 11),
      plot.title = element_text(),
      axis.title = element_blank(),
      legend.position = "none",
      panel.grid.minor = element_blank()
      # axis.text.x = element_blank()
    ),
  plotList[[3]] +
    theme(
      axis.text = ggplot2::element_text(size = 11),
      plot.title = element_text(),
      axis.title = element_blank(),
      panel.grid.minor = element_blank(),
      legend.position = "none"
    ),
  plotList[[4]] +
    theme(
      axis.text = ggplot2::element_text(size = 11),
      plot.title = element_text(),
      axis.title = element_blank(),
      panel.grid.minor = element_blank(),
      legend.position = "none"
    ),
  heights = c(1, 1.05),
  nrow = 2,
  ncol = 2,
  left = grid::textGrob(
    expression(
      paste(
        "Calibration for benefit (x",
        10^-2,
        ")"
      )
    ),
    rot = 90,
    gp = grid::gpar(col = "black", fontsize = 14)
  ),
  bottom = grid::textGrob(
    "Method",
    just = "center",
    gp = grid::gpar(fontsize = 14)
  )
)
dev.off()

# ggsave(
#   file.path("figures", fileName),
#   res,
#   height = 9.5,
#   width = 10,
#   dpi = 1000,
#   compression = "lzw+p",
#   bg = "#F1F3F8"
# )
