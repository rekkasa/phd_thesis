#!/usr/bin/env Rscript
library(tidyverse)
library(scales)
library(gridExtra)
library(grid)
library(gridtext)

scaleFUN <- function(x) sprintf("%.1f", x)

databases <- c("ccae", "mdcd", "mdcr")
map_exposures <- readRDS("data/framework/map_exposures.rds")
pp <- psData <- list()
overlap <- character(3)

for (i in seq_along(databases)) {
  pattern <- paste0("^ps.*", databases[i], "_730_analysis_", databases[i], "_ps_strat_acute_myocardial_infarction_15_1_2_2.rds")
  psData[[i]] <- list.files(
    path = "data/framework",
    pattern = pattern,
    full.names = TRUE
  ) %>%
    readRDS() %>%
    dplyr::mutate(
      treatment = ifelse(
        treatment == 1,
        treatmentId,
        comparatorId
      ),
      riskStratum = case_when(
        riskStratum == "Q1" ~ "RG-1",
        riskStratum == "Q2" ~ "RG-2",
        riskStratum == "Q3" ~ "RG-3"
      )
    ) %>%
    dplyr::left_join(
      map_exposures,
      by = c("treatment" = "exposure_id")
    )

  for (j in 1:3) {
    dTreatment <- psData[[i]] %>%
      filter(
        treatment == 15,
        riskStratum == paste("RG", j, sep = "-")
      ) %>%
      select(x, y)
    dControl <- psData[[i]] %>% filter(
      treatment == 1,
      riskStratum == paste("RG", j, sep = "-")
    ) %>% select(x, y)

    f1 <- approxfun(dTreatment$x, dTreatment$y)
    f2 <- approxfun(dControl$x, dControl$y)
    dd <- dplyr::tibble(
      x = seq(0, 1, length.out = 1e3),
      y1 = f1(x),
      y2 = f2(x)
    )
    dd$min <- pmin(dd$y1, dd$y2)
    dd$max <- pmax(dd$y1, dd$y2)
    fmin <- approxfun(dd$x, dd$min)
    fmax <- approxfun(dd$x, dd$max)

    total <- integrate(fmax, 0, 1)$value
    intersection <- integrate(fmin, 0, 1)$value
    overlap[j] <- paste0(format(round(100 * intersection/total, 1), nsmall=1), "%")
  }

  annotations <- data.frame(
    riskStratum = paste("RG", 1:3, sep = "-"),
    overlap = overlap
  )

  pp[[i]] <- ggplot2::ggplot(
    data = psData[[i]],
    ggplot2::aes(
      x = x,
      y = y
    )
  ) +
    ggplot2::geom_density(
      stat = "identity",
      ggplot2::aes(
        color = exposure_name,
        group = exposure_name,
        fill = exposure_name
      )
    ) +
    scale_x_continuous(
      breaks = seq(0, 1, .5)
    ) +
    scale_y_continuous(breaks = 0:3) +
    ggplot2::facet_grid(~riskStratum) +
    # ggplot2::ylab(
    #   label = toupper(databases[i])
    # ) +
    ggplot2::xlab(
      label = "Preference score"
    ) +
    ggplot2::scale_fill_manual(
      values = alpha(c("#fc8d59", "#91bfdb"), .6)
    ) +
    ggplot2::scale_color_manual(
      values = alpha(c("#fc8d59", "#91bfdb"), .9)
    ) +
    theme_classic() +
    ggplot2::theme(
      legend.title    = ggplot2::element_blank(),
      legend.position = "none",
      axis.title.x    = element_blank(),
      axis.title.y    = element_blank(),
      # axis.line.y     = element_blank(),
      # axis.ticks.y    = element_blank(),
      # axis.text.y     = element_blank(),
      axis.text.x     = element_text(size = 22),
      axis.text.y     = element_text(size = 22),
      axis.title      = element_text(size = 30),
      strip.text      = element_text(size = 25)
    )
  pp[[i]] <- pp[[i]] +
    ggplot2::geom_text(
      data = annotations,
      mapping = ggplot2::aes(x = -Inf, y = -Inf, label = overlap),
      hjust   = -6,
      vjust   = -2,
      size    = 6
    )

  if (i != 1) {
    pp[[i]] <- pp[[i]] +
      theme(
        strip.text       = element_blank(),
        strip.background = element_blank()
      )
  } else {
    pp[[i]] <- pp[[i]] +
      ggplot2::theme(
        legend.position = c(.066, .9),
        legend.text = element_text(size = 14.2)
      )
  }
}

bottom <- textGrob("Preference score", gp = gpar(fontsize = 30))
left <- textGrob("Density", gp = gpar(fontsize = 30), rot = 90)
right <- textGrob(
  "CCAE                                MDCD                                MDCR",
  gp = gpar(fontsize = 30),
  rot = 270
)

plot <- gridExtra::grid.arrange(
  pp[[1]],
  pp[[2]],
  pp[[3]],
  bottom = bottom,
  left = left,
  right = right,
  nrow = 3
)
ggsave(
  "figures/ch3-PsDensity.tiff",
  plot,
  compression = "lzw",
  height = 6,
  width = 8,
  dpi = 1000,
  compression = "lzw+p",
  bg = "#F0F2F3"
)
