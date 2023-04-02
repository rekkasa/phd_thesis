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
    scale_y_continuous(limits = c(0, 4), breaks = 0:4) +
    ggplot2::facet_grid(~riskStratum) +
    ggplot2::xlab(
      label = "Preference score"
    ) +
    ggplot2::scale_fill_manual(
      values = alpha(c("#F99B45", "#63AAC0"), .8)
    ) +
    ggplot2::scale_color_manual(
      values = alpha(c("#F99B45", "#63AAC0"), .9)
    ) +
    ggplot2::theme(
      plot.background = ggplot2::element_rect(fill = "#F1F3F8"),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "#F0F2F3"),
      legend.title    = ggplot2::element_blank(),
      legend.position = "none",
      axis.line       = element_line(color = "black"),
      axis.title.x    = element_blank(),
      axis.title.y    = element_blank(),
      axis.text.x     = element_text(size = 7),
      axis.text.y     = element_text(size = 7),
      axis.title      = element_text(size = 10),
      strip.text      = element_text(size = 10),
      panel.spacing    = unit(0, "mm"),
      plot.margin = unit(c(4, 0, 0, 0), "mm")
    )
  pp[[i]] <- pp[[i]] +
    ggplot2::geom_text(
      data = annotations,
      mapping = ggplot2::aes(x = -Inf, y = -Inf, label = overlap),
      hjust   = -3.1,
      vjust   = -1,
      size    = 2.5
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
        legend.position = c(.13, .9),
        legend.text = element_text(size = 6),
        legend.background = element_blank(),
        legend.key.size = unit(3.5, "mm")
      )
  }
}

bottom <- textGrob("Preference score", gp = gpar(fontsize = 10))
left <- textGrob("Density", gp = gpar(fontsize = 10), rot = 90)
right <- textGrob(
  "CCAE                                MDCD                                MDCR",
  gp = gpar(fontsize = 10),
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
  height = 5,
  width = 6.5,
  dpi = 1000,
  compression = "lzw+p",
  bg = "#F1F3F8"
)
