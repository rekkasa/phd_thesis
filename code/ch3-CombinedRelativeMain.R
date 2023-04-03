#!/usr/bin/env Rscript

library(tidyverse)
library(scales)

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
fileType <- as.character(args[3])

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
      by = c("stratOutcome" = "outcome_id"),
      relationship = "many-to-many"
    ) %>%
    select(-stratOutcome) %>%
    rename("stratOutcome" = "outcome_name") %>%
    left_join(
      map_outcomes,
      by = c("estOutcome" = "outcome_id"),
      relationship = "many-to-many"
    ) %>%
    select(-estOutcome) %>%
    rename("estOutcome" = "outcome_name") %>%
    left_join(
      map_exposures,
      by = c("treatment" = "exposure_id"),
      relationship = "many-to-many"
    ) %>%
    select(-treatment) %>%
    rename("treatment" = "exposure_name") %>%
    left_join(
      map_exposures,
      by = c("comparator" = "exposure_id"),
      relationship = "many-to-many"
    ) %>%
    select(-comparator) %>%
    rename("comparator" = "exposure_name")
}


relative <- prepareDataset(mappedOverallRelativeResults) %>%
  filter(
    analysisType == psAnalysis,
    stratOutcome == stratificationOutcome,
    estOutcome %in% c(
      "Acute myocardial infarction",
      "Hospitalization with heart failure",
      "Stroke"
    )
  ) %>%
  mutate(
    database = toupper(database),
    estOutcome = factor(
      estOutcome,
      levels = c(
        "Acute myocardial infarction",
        "Hospitalization with heart failure",
        "Stroke"
      ),
      labels = c(
        "Acute myocardial infarction",
        "Hosp. with heart failure",
        "Stroke"
      )
    )
  ) %>%
  filter(
    estOutcome %in% c(
      "Acute myocardial infarction",
      "Hosp. with heart failure",
      "Stroke"
    )
  )

scale_y <- scale_y_continuous(
  trans = "log10",
  breaks = c(.4, .5, .7, 1, 1.5, 2.5),
  limits = c(.4, 2.5),
  name = "Hazard ratio",
  oob = rescale_none
)

relativePlot <- ggplot(
  data = relative %>% na.omit(),
  aes(
    x = riskStratum,
    y = estimate,
    ymin = lower,
    ymax = upper,
    color = database,
    group = database
  )
) +
  facet_wrap(~estOutcome, scales = "free") +
  geom_point(position = position_dodge(width = .6), size = 2.5) +
  geom_line(position = position_dodge(width = .6), linetype = 2, alpha = .55) +
  geom_errorbar(position = position_dodge(width = .6), width = 0, size = 0.7) +
  scale_y +
  xlab("Risk subgroup") +
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
  guides(col = guide_legend(nrow = 1)) +
  theme(
    plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
    panel.grid.minor = ggplot2::element_blank(),
    panel.background = ggplot2::element_rect(fill = "#F0F2F3", color = "black", linetype = 1),
    legend.position = "top",
    legend.background = ggplot2::element_rect(fill = "#F1F3F8"),
    legend.title = element_blank(),
    legend.text = element_text(size = 10),
    legend.key = element_rect(fill = "#F0F2F3"),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    # axis.line = element_line(color = "black"),
    strip.text = element_text(size = 12, color = "black"),
    strip.background = element_rect(fill = "#F1F3F8"),
    panel.spacing = unit(2, "mm"),
    plot.margin = unit(c(0, 4, 0, 0), "mm")
  )

ggsave(
  "figures/ch3-RelativeResultsMain.tiff",
  relativePlot,
  height = 3.5,
  width = 8,
  dpi = 1000,
  compression = "lzw+p",
  bg = "#F1F3F8"
)
