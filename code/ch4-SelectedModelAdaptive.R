#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(tidyverse)
  library(ggthemes)
})

args <- commandArgs(trailingOnly = TRUE)
args_base <- as.character(args[1])
args_sampleSize <- as.numeric(args[2])
args_auc <- as.numeric(args[3])
args_value <- as.character(args[4])

analysisIds <- read_csv("data/simulation/analysisIds.csv")

scenarios <- analysisIds %>%
  filter(
    base == args_base,
    !(type %in% c("quadratic-moderate", "linear-moderate")),
    harm != "negative",
    sampleSize == args_sampleSize,
    auc == args_auc
  ) %>%
  pull(scenario)

adaptiveModel <- readr::read_csv("data/simulation/adaptiveModel.csv") %>%
  filter(scenarioId %in% scenarios) %>%
  left_join(analysisIds, by = c("scenarioId" = "scenario")) %>%
  select(
    c("selectedAdaptiveModel", "type", "harm")
  ) %>%
  mutate(
    selectedAdaptiveModel = factor(
      selectedAdaptiveModel,
      levels = rev(
        c(
          "treatment",
          "risk",
          "RCS with 3 knots",
          "RCS with 4 knots",
          "RCS with 5 knots"
        )
      ),
      labels = rev(
        c(
          "Constant treatment\neffect",
          "Linear interaction",
          "RCS-3",
          "RCS-4",
          "RCS-5"
        )
      )
    ),
    type = factor(
      type,
      levels = c(
        "constant",
        "linear-high",
        "quadratic-high",
        "non-monotonic"
      ),
      labels = c(
        "Constant treatment\neffect",
        "Strong linear\ndeviation",
        "Strong quadratic\ndeviation",
        "Non-monotonic\ndeviation"
      )
    )
  )

p <- ggplot2::ggplot(
  data = adaptiveModel,
  ggplot2::aes(x = harm, fill = selectedAdaptiveModel)
) +
  ggplot2::geom_bar(position = "fill") +
  scale_fill_manual(
    values = c(
      "#284E60",
      "#F99B45",
      "#63AAC0",
      "#D95980",
      "#4DA48F"
    ),
    breaks = c(
      "Constant treatment\neffect",
      "Linear interaction",
      "RCS-3",
      "RCS-4",
      "RCS-5"
    )
  ) +
  facet_grid(~type) +
  scale_x_discrete(
    breaks = c(
      "absent",
      "moderate-positive",
      "strong-positive"
    ),
    labels = c(
      "Absent",
      "Moderate",
      "Strong"
    )
  ) +
  xlab("Treatment-related harm") +
  ylab("Model selection rate") +
  theme(
    axis.title = element_text(size = 13),
    axis.text.y = element_text(size = 11),
    axis.text.x = element_text(size = 11, angle = 25, vjust = 1, hjust = 1),
    strip.text = element_text(size = 12),
    strip.background = element_blank() ,
    legend.position = "bottom",
    legend.title = element_blank(),
    legend.text = element_text(size = 11),
    panel.grid.minor = ggplot2::element_blank(),
    panel.grid.major.x = ggplot2::element_blank(),
    plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
    panel.background = ggplot2::element_rect(fill = "#F0F2F3", color = "black", linetype = 1),
    # legend.box.background = ggplot2::element_rect(color = "black"),
    legend.background = ggplot2::element_rect(fill = "#F1F3F8"),
    axis.title.y = ggplot2::element_blank(),
    axis.line = ggplot2::element_line(color = "black")
  )

fileToSave <- paste0(
  paste(
    "ch4-Selected_model_adaptive",
    args_value,
    sep = "_"
  ),
  ".tiff"
)

ggsave(
  file.path("figures", fileToSave),
  p,
    height = 4.5,
    width = 6.9,
    dpi = 1000,
    compression = "lzw+p",
  bg = "#F1F3F8"
)

