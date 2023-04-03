#!/usr/bin/env Rscript

library(tidyverse)
library(scales)
library(grid)
library(gridExtra)

plotCovariateBalanceScatterPlot2 <- function(
    balance,
    absolute = TRUE,
    threshold = 0,
    title = "Standardized difference of mean",
    fileName = NULL,
    beforeLabel = "Before matching",
    afterLabel = "After matching",
    showCovariateCountLabel = FALSE,
    showMaxLabel = FALSE
) {
  beforeLabel <- as.character(beforeLabel)
  afterLabel <- as.character(afterLabel)
  if (absolute) {
    balance$beforeMatchingStdDiff <- abs(balance$beforeMatchingStdDiff)
    balance$afterMatchingStdDiff <- abs(balance$afterMatchingStdDiff)
  }
  plot <- ggplot2::ggplot(
    balance,
    ggplot2::aes(x = .data$beforeMatchingStdDiff, y = .data$afterMatchingStdDiff)
  ) +
    ggplot2::geom_point(color = "#284E60", alpha = .7, shape = 16) +
    ggplot2::geom_abline(slope = 0, intercept = .1, linetype = "dashed") +
    if (threshold != 0) {
      plot <- plot +
        ggplot2::geom_hline(
          yintercept = 0.1,
          alpha = 0.5,
          linetype = "dotted"
        )
    }
  if (showCovariateCountLabel || showMaxLabel) {
    labels <- c()
    if (showCovariateCountLabel) {
      labels <- c(
        labels,
        sprintf(
          "Number of covariates: %s",
          format(nrow(balance),big.mark = ",", scientific = FALSE)
        )
      )
    }
    if (showMaxLabel) {
      labels <- c(
        labels,
        sprintf(
          "%s max(absolute): %.2f",
          afterLabel,
          max(abs(balance$afterMatchingStdDiff), na.rm = TRUE)
        )
      )
    }
    dummy <- data.frame(text = paste(labels, collapse = "\n"))
    plot <- plot +
      ggplot2::geom_label(
        x = limits[1] + 0.01,
        y = limits[2],
        hjust = "left",
        vjust = "top",
        alpha = 0.8,
        ggplot2::aes(label = text),
        data = dummy,
        size = 3.5
      )
  }
  if (!is.null(fileName)) {
    ggplot2::ggsave(fileName, plot, width = 4, height = 4, dpi = 400)
  }
  return(plot)
}

.truncRight <- function(x, n) {
  nc <- nchar(x)
  x[nc > (n - 3)] <- paste(
    "...",
    substr(x[nc > (n - 3)], nc[nc > (n - 3)] - n + 1, nc[nc > (n - 3)]),
    sep = ""
  )
  x
}

databases <- c("ccae", "mdcd", "mdcr")
map_exposures <- readRDS("data/framework/map_exposures.rds")
pp <- list()

for (i in seq_along(databases)) {
  pattern <- paste0("^balance.*", databases[i], "_730_analysis_", databases[i], "_ps_strat_acute_myocardial_infarction_15_1_2_2.rds")
  pp[[i]] <- list.files(
    path = "data/framework",
    pattern = pattern,
    full.names = TRUE
  ) %>%
    readRDS() %>%
    bind_rows() %>%
    mutate(
      riskStratum = case_when(
        riskStratum == "Q1" ~ "RG-1",
        riskStratum == "Q2" ~ "RG-2",
        riskStratum == "Q3" ~ "RG-3"
      )
    ) %>%
    tibble() %>%
    plotCovariateBalanceScatterPlot2(
      beforeLabel = "",
      afterLabel = toupper(databases[i])
    ) +
    ggplot2::facet_wrap(
      ~riskStratum,
      scales = "free"
    ) +
    ggplot2::scale_x_continuous(
      limits = c(0, .43),
      breaks = seq(0, .4, .1)
    ) +
    ggplot2::scale_y_continuous(
      limits = c(0, .43),
      breaks = seq(0, .4, .1)
    ) +
    ggplot2::theme(
      plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "#F0F2F3"),
      legend.title    = ggplot2::element_blank(),
      legend.position = "none",
      axis.line       = element_line(color = "black"),
      axis.line.y     = element_line(color = "black"),
      axis.title.x    = element_blank(),
      axis.title.y    = element_blank(),
      axis.text.x     = element_text(size = 10),
      axis.text.y     = element_text(size = 10),
      axis.title      = element_text(size = 14),
      strip.text      = element_text(size = 14),
      strip.background = element_rect(fill = "#F1F3F8"),
      panel.spacing    = unit(4, "mm"),
      plot.margin = unit(c(4, 0, 0, 0), "mm")
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
        legend.position = c(.5, .9),
        legend.text = element_text(size = 8),
        legend.background = element_blank(),
        legend.key.size = unit(3.5, "mm"),
        legend.direction = "horizontal"
      )
  }
}

left <- textGrob("After stratification on PS", gp = gpar(fontsize = 14), rot = 90)
bottom <- textGrob("Before stratification on PS", gp = gpar(fontsize = 14))
right <- textGrob(
  "CCAE                           MDCD                          MDCR",
  gp = gpar(fontsize = 14),
  rot = 270
)

plot <- gridExtra::grid.arrange(
  grobs = pp,
  nrow = 3,
  bottom = bottom,
  left = left,
  right = right
)
# plot <- gridExtra::grid.arrange(pp[[1]], pp[[2]], pp[[3]], nrow = 3)
ggsave(
  "figures/ch3-CovariateBalance.tiff",
  plot,
  height = 5.5,
  width = 7.5,
  dpi = 1000,
  compression = "lzw+p",
  bg = "#F1F3F8"
)
