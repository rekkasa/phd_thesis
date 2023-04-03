#!/usr/bin/env Rscript


library(tidyverse)
library(scales)
library(grid)
library(gridExtra)

args <- commandArgs(trailingOnly = TRUE)
stratOutcomeTitle <- as.character(args[1])
stratificationOutcome  <- gsub("_", " ", stratOutcomeTitle, fixed = TRUE) %>%
  str_to_sentence()
psAnalysisType <- args[2]
psAnalysis <- ifelse(
  test = psAnalysisType == "main",
  yes = paste("ps", "strat", stratOutcomeTitle, sep = "_"),
  no = paste("ps", "strat", stratOutcomeTitle, psAnalysisType, sep = "_")
)

mappedOverallRelativeResults <- readRDS(
  "data/framework/mappedOverallRelativeResults.rds"
) %>%
  mutate(
    estimate = ifelse(
      database == "ccae" & riskStratum == "Q3",
      NA,
      estimate
    ),
    riskStratum = case_when(
      riskStratum == "Q1" ~ "RG-1",
      riskStratum == "Q2" ~ "RG-2",
      riskStratum == "Q3" ~ "RG-3"
    )
  )

map_outcomes <- readRDS(
  "data/framework/map_outcomes.rds"
) %>%
  select(-stratification_outcome)

map_exposures <- readRDS(
  "data/framework/map_exposures.rds"
)

prepareDataset <- function(data) {
  data %>%
    left_join(
      map_outcomes,
      by = c("stratOutcome" = "outcome_id")
    ) %>%
    select(-stratOutcome) %>%
    rename("stratOutcome" = "outcome_name") %>%
    left_join(
      map_outcomes,
      by = c("estOutcome" = "outcome_id")
    ) %>%
    select(-estOutcome) %>%
    rename("estOutcome" = "outcome_name") %>%
    left_join(
      map_exposures,
      by = c("treatment" = "exposure_id")
    ) %>%
    select(-treatment) %>%
    rename("treatment" = "exposure_name") %>%
    left_join(
      map_exposures,
      by = c("comparator" = "exposure_id")
    ) %>%
    select(-comparator) %>%
    rename("comparator" = "exposure_name")
}


relative <- prepareDataset(mappedOverallRelativeResults) %>%
  filter(
    analysisType == psAnalysis,
    stratOutcome == stratificationOutcome,
    estOutcome %in% c(
      "Acute renal failure",
      "Angioedema",
      "Cough",
      "Gastrointestinal bleeding",
      "Hyperkalemia",
      "Hypokalemia",
      "Hyponatremia",
      "Hypotension",
      "Kidney disease"
    )
  ) %>%
  mutate(
    database = toupper(database),
    estOutcome = factor(
      estOutcome,
      levels = c(
      "Acute renal failure",
      "Angioedema",
      "Cough",
      "Gastrointestinal bleeding",
      "Hyperkalemia",
      "Hypokalemia",
      "Hyponatremia",
      "Hypotension",
      "Kidney disease"
      )
    )
  )

scale_y <- scale_y_continuous(
  trans = "log10",
  breaks = c(.3, .5, .7, 1, 2, 5),
  limits = c(.2, 7.5),
  name = "Hazard ratio",
  oob = rescale_none
)

scaleFUN <- function(x) sprintf("%.2f", x)

plotList <- list()
for (i in seq_along(levels(relative$estOutcome))) {
  plotList[[i]] <- ggplot(
    data = relative %>% filter(estOutcome == levels(estOutcome)[i]) %>% na.omit(),
    aes(
      x = riskStratum,
      y = estimate,
      ymin = lower,
      ymax = upper,
      color = database,
      group = database
    )
  ) +
    facet_grid(cols = vars(estOutcome)) +
    # facet_wrap(~estOutcome, scales = "free") +
    geom_point(position = position_dodge(width = .6), size = 2.5) +
    geom_line(position = position_dodge(width = .6), linetype = 2, alpha = .55) +
    geom_errorbar(position = position_dodge(width = .6), width = 0, size = 0.7) +
    # scale_y +
    xlab("Risk group") +
    geom_hline(
      aes(yintercept = 1),
      linetype = 2
    ) +
  scale_color_manual(
    values = c(
      "#284E60",
      "#F99B45",
      "#63AAC0"
    ),
    breaks = c("CCAE", "MDCD", "MDCR")
  ) +
    guides(col = guide_legend(nrow = 1))
}

gridList <- list(
  plotList[[1]] +
    scale_y_continuous(
      trans = "log10",
      breaks = c(.5, .7, 1, 2),
      limits = c(.5, 2.5),
      oob = rescale_none
    ) +
    theme(
      plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
      panel.grid.minor = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "#F0F2F3", color = "black", linetype = 1),
      # legend.background = ggplot2::element_rect(fill = "#F1F3F8"),
      legend.background = ggplot2::element_blank(),
      legend.title = element_blank(),
      legend.text = element_text(size = 8),
      legend.key = element_rect(fill = "#F0F2F3"),
      axis.text = element_text(size = 10),
      # axis.line = element_line(color = "black"),
      strip.text = element_text(size = 12, color = "black"),
      strip.background = element_rect(fill = "#F1F3F8"),
      panel.spacing = unit(1, "mm"),
      plot.margin = unit(c(0, 4, 0, 0), "mm"),
      legend.position = c(.5, .91),
      # axis.text = element_text(size = 25),
      axis.title = element_blank()
    ),
  plotList[[2]] +
    scale_y_continuous(
      trans = "log10",
      breaks = c(0, .1, .2, .4 , 1, 2, 4),
      limits = c(.1, 4),
      oob = rescale_none
    ) +
    theme(
      plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
      panel.grid.minor = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "#F0F2F3", color = "black", linetype = 1),
      legend.background = ggplot2::element_rect(fill = "#F1F3F8"),
      legend.key = element_rect(fill = "#F0F2F3"),
      axis.text = element_text(size = 10),
      strip.text = element_text(size = 12, color = "black"),
      strip.background = element_rect(fill = "#F1F3F8"),
      panel.spacing = unit(1, "mm"),
      plot.margin = unit(c(0, 4, 0, 0), "mm"),
      legend.position = "none",
      # axis.text = element_text(size = 25),
      axis.title = element_blank()
    ),
  plotList[[3]] +
    scale_y_continuous(
      trans = "log10",
      breaks = c(.5, .7, 1, 1.5),
      limits = c(.5, 1.5),
      oob = rescale_none
    ) +
    theme(
      plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
      panel.grid.minor = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "#F0F2F3", color = "black", linetype = 1),
      legend.background = ggplot2::element_rect(fill = "#F1F3F8"),
      legend.title = element_blank(),
      legend.key = element_rect(fill = "#F0F2F3"),
      axis.text = element_text(size = 10),
      strip.text = element_text(size = 12, color = "black"),
      strip.background = element_rect(fill = "#F1F3F8"),
      panel.spacing = unit(1, "mm"),
      plot.margin = unit(c(0, 4, 0, 0), "mm"),
      legend.position = "none",
      axis.title = element_blank()
    ),
  plotList[[4]] +
    theme(
      plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
      panel.grid.minor = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "#F0F2F3", color = "black", linetype = 1),
      legend.background = ggplot2::element_rect(fill = "#F1F3F8"),
      legend.title = element_blank(),
      legend.key = element_rect(fill = "#F0F2F3"),
      axis.text = element_text(size = 10),
      strip.text = element_text(size = 12, color = "black"),
      strip.background = element_rect(fill = "#F1F3F8"),
      panel.spacing = unit(1, "mm"),
      plot.margin = unit(c(0, 4, 0, 0), "mm"),
      legend.position = "none",
      axis.title = element_blank()
    ),
  plotList[[5]] +
    theme(
      plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
      panel.grid.minor = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "#F0F2F3", color = "black", linetype = 1),
      legend.background = ggplot2::element_rect(fill = "#F1F3F8"),
      legend.title = element_blank(),
      legend.key = element_rect(fill = "#F0F2F3"),
      axis.text = element_text(size = 10),
      strip.text = element_text(size = 12, color = "black"),
      strip.background = element_rect(fill = "#F1F3F8"),
      panel.spacing = unit(1, "mm"),
      plot.margin = unit(c(0, 4, 0, 0), "mm"),
      legend.position = "none",
      # axis.text = element_text(size = 25),
      axis.title = element_blank()
    ),
  plotList[[6]] +
    scale_y_continuous(
      trans = "log10",
      breaks = c(1.5, 2.5, 4.5, 7),
      limits = c(1.5, 7),
      oob = rescale_none
    ) +
    theme(
      plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
      panel.grid.minor = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "#F0F2F3", color = "black", linetype = 1),
      legend.background = ggplot2::element_rect(fill = "#F1F3F8"),
      legend.title = element_blank(),
      legend.key = element_rect(fill = "#F0F2F3"),
      axis.text = element_text(size = 10),
      strip.text = element_text(size = 12, color = "black"),
      strip.background = element_rect(fill = "#F1F3F8"),
      panel.spacing = unit(1, "mm"),
      plot.margin = unit(c(0, 4, 0, 0), "mm"),
      legend.position = "none",
      # axis.text = element_text(size = 25),
      axis.title = element_blank()
    ),
  plotList[[7]] +
    theme(
      plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
      panel.grid.minor = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "#F0F2F3", color = "black", linetype = 1),
      legend.background = ggplot2::element_rect(fill = "#F1F3F8"),
      legend.title = element_blank(),
      legend.key = element_rect(fill = "#F0F2F3"),
      axis.text = element_text(size = 10),
      strip.text = element_text(size = 12, color = "black"),
      strip.background = element_rect(fill = "#F1F3F8"),
      panel.spacing = unit(1, "mm"),
      plot.margin = unit(c(0, 4, 0, 0), "mm"),
      legend.position = "none",
      axis.title = element_blank()
    ),
  plotList[[8]] +
    scale_y_continuous(
      trans = "log10",
      breaks = c(.3, .4, .6, 1, 2),
      limits = c(.3, 2),
      oob = rescale_none
    ) +
    theme(
      plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
      panel.grid.minor = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "#F0F2F3", color = "black", linetype = 1),
      legend.background = ggplot2::element_rect(fill = "#F1F3F8"),
      legend.title = element_blank(),
      legend.key = element_rect(fill = "#F0F2F3"),
      axis.text = element_text(size = 10),
      strip.text = element_text(size = 12, color = "black"),
      strip.background = element_rect(fill = "#F1F3F8"),
      panel.spacing = unit(1, "mm"),
      plot.margin = unit(c(0, 4, 0, 0), "mm"),
      legend.position = "none",
      axis.title = element_blank()
    ),
  plotList[[9]] +
    theme(
      plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
      panel.grid.minor = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "#F0F2F3", color = "black", linetype = 1),
      legend.background = ggplot2::element_rect(fill = "#F1F3F8"),
      legend.title = element_blank(),
      legend.key = element_rect(fill = "#F0F2F3"),
      axis.text = element_text(size = 10),
      strip.text = element_text(size = 12, color = "black"),
      strip.background = element_rect(fill = "#F1F3F8"),
      panel.spacing = unit(1, "mm"),
      plot.margin = unit(c(0, 4, 0, 0), "mm"),
      legend.position = "none",
      axis.title = element_blank()
    )
)
left <- textGrob("Hazard ratio", gp = gpar(fontsize = 12), rot = 90)
bottom <- textGrob("Risk group", gp = gpar(fontsize = 12))
relativePlot <- gridExtra::grid.arrange(
  grobs = gridList,
  nrow = 3,
  bottom = bottom,
  left = left
)


ggsave(
  "figures/ch3-RelativeResultsSafety.tiff",
  relativePlot,
  height = 6.5,
  width = 8,
  dpi = 1000,
  compression = "lzw+p",
  bg = "#F1F3F8"
)
