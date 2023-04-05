#!/usr/bin/env Rscript

# ===================================================
# Description:
#   Generates the RMSE plots for the base case
# Input:
#   - sample size
#   - auc
#   - value
# Output:
#   - figures/rmse_base.tiff
# Depends:
#   - data/processed/analysisIds.csv
#   - data/processed/rmse.csv
#   - code/helpers/CreateManuscriptPlots.R
#   - code/helpers/PlotResult.R
#   - code/helpers/Absolute.R
# ===================================================

args <- commandArgs(trailingOnly = TRUE)
args_base <- as.character(args[1])
args_sampleSize <- as.numeric(args[2])
args_auc <- as.numeric(args[3])
args_value <- as.character(args[4])

library(tidyverse)
library(glue)
library(ggtext)
library(gridExtra)
library(grid)
library(ggside)

# --------------------------------------
# Sourcing helper files:
#   1. Generates single boxplot
#   2. Generates the boxplot list
#   3. Generates the absolute plots
# --------------------------------------
source("code/ch4-CreateManuscriptPlots.R")
source("code/ch4-PlotResult.R")
source("code/ch4-Absolute.R")

scenarioIds <- readr::read_csv("data/simulation/analysisIds.csv") %>%
  filter(
    base == args_base,
    !(type %in% c("quadratic-moderate", "linear-moderate")),
    sampleSize == args_sampleSize,
    auc == args_auc
  )

metric    <- "rmse"

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

limitsHigh <- ifelse(
  args_base == "high",
  yes = .2,
  no = .15
)

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

# ----------------------------------
# Create the absolute benefit plots
# ----------------------------------
absolutePlots <- scenarioIds %>%
  filter(harm != "negative") %>%
  group_by(type) %>%
  nest() %>%
  mutate(
    plot = map2(
      data,
      type,
      ~ plotAbsoluteBenefit(
        data = .x,
        projectDir = ".",
        type = .y
      )
    )
  )

# --------------------
# Create the boxplots
# --------------------
scenarios <- scenarioIds %>%
  filter(harm == "absent") %>%
  select(scenario) %>%
  unlist()

names(scenarios) <- NULL

plotList <- plotResult(scenarios, processed, titles, metric = metric, limits = c(0, 10, 2.5))


# ------------------------------------
# Put them all together:
#   - create a list of plots
#   - combine the list with cowplot
# ------------------------------------
gridList <- list(
  plotList[[1]] +
    theme(
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
      panel.background = ggplot2::element_rect(fill = "#F0F2F3", color = "black", linetype = 1),
      plot.title = element_text(size = 12),
      axis.title.x = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_blank(),
      # axis.text.x = element_blank(),
      axis.text.x = element_text(size = 10),
      axis.text.y = element_text(size = 10),
      legend.direction = "horizontal",
      legend.title = element_text(size = 9.5),
      legend.text = element_text(size = 9),
      legend.position = c(.458, .792),
      # legend.box.background = ggplot2::element_rect(color = "black"),
      legend.box.background = ggplot2::element_blank(),
      # legend.background = ggplot2::element_rect(fill = "#F1F3F8")
      legend.background = ggplot2::element_blank()
    ),
  absolutePlots$plot[[1]] +
    ggtitle("True absolute benefit") +
    xlim(c(0, .5)) +
    scale_y_continuous(
      position = "right",
      limits = c(-.058, limitsHigh),
      breaks = seq(-.05, limitsHigh, .05)
    ) +
    scale_color_manual(
      name = "Constant treatment-\n related harm",
      values = c(
        "#284E60",
        "#F99B45",
        "#63AAC0"
      ),
    ) +
    theme(
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
      panel.background = ggplot2::element_rect(fill = "#F0F2F3", color = "black", linetype = 1),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      # axis.text.x = element_blank(),
      axis.text.x = element_text(size = 10),
      axis.text.y = element_text(size = 10),
      ggside.line = element_blank(),
      ggside.rect = element_blank(),
      ggside.axis.text = element_blank(),
      ggside.axis.ticks.length = unit(0, "pt"),
      ggside.panel.scale = .07,
      plot.title = element_text(size = 12),
      legend.position = "none"
    ),
  plotList[[2]] +
    theme(
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
      panel.background = ggplot2::element_rect(fill = "#F0F2F3", color = "black", linetype = 1),
      plot.title = element_text(size = 12),
      axis.title = element_blank(),
      # axis.text.x = element_blank(),
      axis.text.x = element_text(size = 10),
      axis.text.y = element_text(size = 10),
      ggside.line = element_blank(),
      ggside.rect = element_blank(),
      ggside.axis.text = element_blank(),
      ggside.axis.ticks.length = unit(0, "pt"),
      ggside.panel.scale = .07,
      legend.position = "none"
    ),
  absolutePlots$plot[[2]] +
    ggtitle("True absolute benefit in treatment arm") +
    xlim(c(0, .5)) +
    scale_y_continuous(
      position = "right",
      limits = c(-.058, limitsHigh),
      breaks = seq(-.05, limitsHigh, .05)
    ) +
    scale_color_manual(
      name = "Constant treatment-\n related harm",
    values = c(
      "#284E60",
      "#F99B45",
      "#63AAC0"
    ),
    ) +
    theme(
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
      panel.background = ggplot2::element_rect(fill = "#F0F2F3", color = "black", linetype = 1),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      # axis.text.x = element_blank(),
      axis.text.x = element_text(size = 10),
      axis.text.y = element_text(size = 10),
      ggside.line = element_blank(),
      ggside.rect = element_blank(),
      ggside.axis.text = element_blank(),
      ggside.axis.ticks.length = unit(0, "pt"),
      ggside.panel.scale = .07,
      plot.title = element_text(size = 12, color = "#F1F3F8"),
      legend.position = "none"
    ),
  plotList[[3]] +
    theme(
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
      panel.background = ggplot2::element_rect(fill = "#F0F2F3", color = "black", linetype = 1),
      plot.title = element_text(size = 12),
      axis.title = element_blank(),
      # axis.text.x = element_blank(),
      axis.text.x = element_text(size = 10),
      legend.position = "none"
    ),
  absolutePlots$plot[[3]] +
    ggtitle("True absolute benefit in treatment arm") +
    xlim(c(0, .5)) +
    scale_y_continuous(
      position = "right",
      limits = c(-.058, limitsHigh),
      breaks = seq(-.05, limitsHigh, .05)
    ) +
    scale_color_manual(
      name = "Constant treatment-\n related harm",
      values = c(
        "#284e60",
        "#f99b45",
        "#63aac0"
      ),
    ) +
    theme(
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
      panel.background = ggplot2::element_rect(fill = "#F0F2F3", color = "black", linetype = 1),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      axis.text.y = element_text(size = 10),
      # axis.text.x = element_blank(),
      axis.text.x = element_text(size = 10),
      ggside.line = element_blank(),
      ggside.rect = element_blank(),
      ggside.axis.text = element_blank(),
      ggside.axis.ticks.length = unit(0, "pt"),
      ggside.panel.scale = .07,
      plot.title = element_text(size = 12, color = "#F1F3F8"),
      legend.position = "none"
    ),
  plotList[[4]] +
    theme(
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
      panel.background = ggplot2::element_rect(fill = "#F0F2F3", color = "black", linetype = 1),
      axis.title = element_blank(),
      # axis.text.x = element_text(size = 8),
      axis.text.x = element_text(size = 10),
      axis.text.y = element_text(size = 10),
      legend.position = "none",
      plot.title = element_text(size = 12)
    ),
  absolutePlots$plot[[4]] +
    ggtitle("Simulated absolute benefit in treatment arm") +
    xlim(c(0, .5)) +
    scale_y_continuous(
      position = "right",
      limits = c(-.058, limitsHigh),
      breaks = seq(-.05, limitsHigh, .05)
    ) +
    scale_color_manual(
      name = "Constant treatment-\n related harm",
      values = c(
        "#284e60",
        "#f99b45",
        "#63aac0"
      ),
    ) +
    theme(
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
      panel.background = ggplot2::element_rect(fill = "#F0F2F3", color = "black", linetype = 1),
      axis.title.x = element_blank(),
      axis.text.x = element_text(size = 10),
      axis.text.y = element_text(size = 10),
      axis.title.y = element_blank(),
      ggside.line = element_blank(),
      ggside.rect = element_blank(),
      ggside.axis.text = element_blank(),
      ggside.axis.ticks.length = unit(0, "pt"),
      ggside.panel.scale = .07,
      plot.title = element_text(size = 12, color = "#F1F3F8"),
      legend.position = "none"
    )
)

pp <- cowplot::plot_grid(
  gridList[[1]],
  gridList[[2]],
  gridList[[3]],
  gridList[[4]],
  gridList[[5]],
  gridList[[6]],
  gridList[[7]],
  gridList[[8]],
  ncol = 2,
  rel_widths = c(1, .5)
)

left.grob <- grid::textGrob(
  expression(
    paste(
      "Root mean squared error (x",
      10^-2,
      ")"
    )
  ),
  rot = 90
)

right.grob <- grid::textGrob(
  "Absolute benefit",
  rot = 270
)

bottom.left.grob <- grid::textGrob(
  "Method",
  just = "center",
  gp = gpar(fontsize = 12)
)

bottom.right.grob <- grid::textGrob(
  "Baseline risk",
  just = "center",
  gp = gpar(fontsize = 12)
)

bottom.grob <- grid.arrange(
  bottom.left.grob,
  bottom.right.grob,
  nrow = 1,
  padding = .2,
  widths = c(2, 1)
)

res <- grid.arrange(arrangeGrob(pp, left = left.grob, right = right.grob, bottom = bottom.grob))

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
  width = 7.5,
  dpi = 1000,
  compression = "lzw+p",
  bg = "#F1F3F8"
)
