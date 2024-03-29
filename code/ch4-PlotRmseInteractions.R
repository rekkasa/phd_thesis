#!/usr/bin/env Rscript

# ===================================================
# Description:
#   Generates the RMSE plots for the base case
# Input:
#   - type
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

library(tidyverse)
library(glue)
library(ggtext)
library(gridExtra)
library(grid)
library(ggside)

args <- commandArgs(trailingOnly = TRUE)
interactionType <- as.character(args[1])

if (interactionType == "positive") {
  scenarioLimits <- c(649, 660)
} else if (interactionType == "negative") {
  scenarioLimits <- c(661, 672)
} else {
  scenarioLimits <- c(673, 676)
}


# --------------------------------------
# Sourcing helper files:
#   1. Generates single boxplot
#   2. Generates the boxplot list
#   3. Generates the absolute plots
# --------------------------------------
source("code/ch4-CreateManuscriptPlots.R")
source("code/ch4-PlotResult.R")
source("code/ch4-Absolute.R")

scenarioIds <- readr::read_csv("data/simulation/analysisIdsInteractions.csv") %>%
  filter(scenario >= scenarioLimits[1] & scenario <= scenarioLimits[2])

metric    <- "rmse"
titles <- scenarioIds %>%
  mutate(
    title = str_to_sentence(glue("{str_replace_all(type, '-', ' ')} interactions")
    )
  ) %>%
  select(title) %>%
  unlist() %>%
  unique()

fileName <- paste0(
  "ch4-",
  paste(
    metric,
    "interaction",
    interactionType,
    sep = "_"
  ),
  ".pdf"
)

if (interactionType != "combined") {
  titlePrefix <- paste0(
    LETTERS[1:3],
    ". "
  )
} else {
  titlePrefix <- ""
}

titles <- paste(
  titlePrefix,
  titles
)

metricFile <- paste(metric, "csv", sep = ".")

f <- function(x) x * 100

limitsHigh <- .15

processed <- readr::read_csv(
  file = file.path("data/simulation", metricFile)
) %>%
  filter(scenarioId >= scenarioLimits[1] & scenarioId <= scenarioLimits[2]) %>%
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

# ------------------------------------
# Create the absolute benefit plots
# ------------------------------------
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


scenarios <- scenarioIds %>%
  filter(harm == "absent") %>%
  select(scenario) %>%
  unlist()

names(scenarios) <- NULL

plotList <- plotResult(
  scenarios,
  processed,
  titles,
  metric = metric,
  limits = c(0, 10, 2.5)
)

if (interactionType == "combined") {
  plotList <- plotResult(
    scenarios,
    processed,
    titles,
    metric = metric,
    limits = c(7.5, 12.5, 1)
  )
  gridList <- list(
    plotList[[1]] +
      theme(
        panel.grid.minor = element_blank(),
        plot.title = element_markdown(size = 14),
        axis.title.x = ggplot2::element_blank(),
        axis.title.y = ggplot2::element_blank(),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        legend.direction = "horizontal",
        legend.title = element_text(size = 12.5),
        legend.text = element_text(size = 12),
        legend.position = c(.420, .938),
        legend.background = ggplot2::element_rect(fill = "#F0F2F3")
      ),
    absolutePlots$plot[[1]] +
      ggtitle("Simulated absolute benefit") +
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
      axis.text.x = element_text(size = 12),
      axis.text.y = element_text(size = 12),
      ggside.line = element_blank(),
      ggside.rect = element_blank(),
      ggside.axis.text = element_blank(),
      ggside.axis.ticks.length = unit(0, "pt"),
      ggside.panel.scale = .07,
      plot.title = element_text(size = 14),
      legend.position = "none"
      )
  )
  pp <- cowplot::plot_grid(
    gridList[[1]],
    gridList[[2]],
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
    rot = 90,
    gp = gpar(fontsize = 14)
  )

  right.grob <- grid::textGrob(
    "Absolute benefit",
    rot = 270,
    gp = gpar(fontsize = 14)
  )

  bottom.left.grob <- grid::textGrob(
    "Method",
    just = "center",
    gp = gpar(fontsize = 14)
  )

  bottom.right.grob <- grid::textGrob(
    "Baseline risk",
    just = "center",
    gp = gpar(fontsize = 14)
  )

  bottom.grob <- grid.arrange(
    bottom.left.grob,
    bottom.right.grob,
    nrow = 1,
    widths = c(2, 1)
  )
  pdf(file.path("figures", fileName), width = 9.8, height = 6.3, bg = "#F1F3F8")
  grid.arrange(
    arrangeGrob(
      pp,
      left = left.grob,
      right = right.grob,
      bottom = bottom.grob
    )
  )
  dev.off()
} else {
  gridList <- list(
    plotList[[1]] +
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
      legend.direction = "horizontal",
      legend.title = element_text(size = 7.5),
      legend.text = element_text(size = 7),
      legend.position = c(.281, .890),
      legend.background = ggplot2::element_rect(fill = "#F0F2F3")
      ),
    absolutePlots$plot[[1]] +
      ggtitle("Simulated absolute benefit") +
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
    )
  )
  pp <- cowplot::plot_grid(
    gridList[[1]],
    gridList[[2]],
    gridList[[3]],
    gridList[[4]],
    gridList[[5]],
    gridList[[6]],
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
    gp = gpar(fontsize = 10)
  )

  bottom.right.grob <- grid::textGrob(
    "Baseline risk",
    just = "center",
    gp = gpar(fontsize = 10)
  )


  bottom.grob <- grid.arrange(
    bottom.left.grob,
    bottom.right.grob,
    nrow = 1,
    widths = c(2, 1)
  )
  pdf(file.path("figures", fileName), width = 9.8, height = 7.8, bg = "#F1F3F8")
  grid.arrange(
    arrangeGrob(
      pp,
      left = left.grob,
      right = right.grob,
      bottom = bottom.grob
    )
  )
  dev.off()
}


# fileName <- paste0(
#   "ch4-",
#   paste(
#     metric,
#     "interaction",
#     interactionType,
#     sep = "_"
#   ),
#   ".tiff"
# )
# ggplot2::ggsave(
#   file.path("figures", fileName),
#   plot = res,
#   dpi = 1200,
#   width = 10,
#   height = 8,
#   compression = "lzw"
# )
