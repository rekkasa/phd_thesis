#!/usr/bin/env Rscript
generateNcPlot <- function(
    logRr,
    seLogRr,
    trueLogRr,
    legacy = FALSE,
    model = NULL,
    xLabel = "Relative risk",
    title,
    fileName = NULL
) {
  alpha <- 0.05
  if (is.null(model)) {
    model <- EmpiricalCalibration::fitSystematicErrorModel(
      logRr = logRr,
      seLogRr = seLogRr,
      trueLogRr = trueLogRr,
      estimateCovarianceMatrix = FALSE,
      legacy = legacy
    )
  } else {
    legacy <- (names(model)[3] == "logSdIntercept")
  }
  d <- data.frame(
    logRr = logRr,
    seLogRr = seLogRr,
    trueLogRr = trueLogRr,
    trueRr = exp(trueLogRr),
    logCi95lb = logRr + qnorm(0.025) * seLogRr,
    logCi95ub = logRr + qnorm(0.975) * seLogRr
  )
  d <- d[!is.na(d$logRr), ]
  d <- d[!is.na(d$seLogRr), ]
  if (nrow(d) == 0) {
    return(NULL)
  }
  d$Group <- as.factor(d$trueRr)
  d$Significant <- d$logCi95lb > d$trueLogRr | d$logCi95ub < d$trueLogRr

  temp1 <- aggregate(Significant ~ trueRr, data = d, length)
  temp2 <- aggregate(Significant ~ trueRr, data = d, mean)
  temp1$nLabel <- paste0(formatC(temp1$Significant, big.mark = ","), " estimates")
  temp1$Significant <- NULL
  temp2$meanLabel <- paste0(
    formatC(100 * (1 - temp2$Significant), digits = 1, format = "f"),
    "% of CIs includes ",
    temp2$trueRr
  )
  temp2$Significant <- NULL
  dd <- merge(temp1, temp2)

  breaks <- c(0.5, 0.75, 1, 1.5, 2)
  theme <- ggplot2::element_text(colour = "#000000", size = 10)
  themeRA <- ggplot2::element_text(colour = "#000000", size = 10, hjust = 1)

  d$Group <- paste("True", tolower(xLabel), "=", d$trueRr)
  dd$Group <- paste("True", tolower(xLabel), "=", dd$trueRr)

  x <- seq(log(0.1), log(10), by = 0.01)
  calBounds <- data.frame()
  for (i in 1:nrow(dd)) {
    mu <- model[1] + model[2]*log(dd$trueRr[i])
    if (legacy) {
      sigma <- exp(model[3] + model[4]*log(dd$trueRr[i]))
    } else {
      sigma <- model[3] + model[4]*abs(log(dd$trueRr[i]))
    }
    calBounds <- rbind(
      calBounds,
      data.frame(
        logRr = x,
        seLogRr = EmpiricalCalibration:::logRrtoSE(x, alpha, mu, sigma),
        Group = dd$Group[i]
      )
    )
  }
  plot <- ggplot2::ggplot(
    d,
    ggplot2::aes(x = .data$logRr, y = .data$seLogRr)
  ) +
    ggplot2::geom_vline(
      xintercept = log(breaks),
      colour = "#AAAAAA",
      lty = 1,
      size = 0.5
    ) +
    ggplot2::geom_abline(
      ggplot2::aes(
        intercept = (-log(.data$trueRr))/qnorm(0.025),
        slope = 1/qnorm(0.025)),
      colour = rgb(0, 0, 0),
      linetype = "dashed",
      size = 1,
      alpha = 0.5,
      data = dd
    ) +
    ggplot2::geom_abline(
      ggplot2::aes(
        intercept = (-log(.data$trueRr))/qnorm(0.975),
        slope = 1/qnorm(0.975)),
      colour = rgb(0, 0, 0),
      linetype = "dashed",
      size = 1,
      alpha = 0.5,
      data = dd
    ) +
    ggplot2::geom_point(
      shape = 16,
      size = 4,
      alpha = 0.8,
      color = "#284E60"
    ) +
    ggplot2::geom_hline(yintercept = 0) +
    ggplot2::geom_text(
      x = log(0.52),
      y = 0.4,
      alpha = 1,
      hjust = "left",
      ggplot2::aes(label = .data$nLabel),
      size = 3.5,
      data = dd
    ) +
    ggplot2::geom_text(
      x = log(0.52),
      y = 0.37,
      alpha = 1,
      hjust = "left",
      ggplot2::aes(label = .data$meanLabel),
      size = 3.5,
      data = dd
    ) +
    ggplot2::scale_x_continuous(
      xLabel,
      limits = log(c(0.5, 2.2)),
      breaks = log(breaks),
      labels = format(signif(breaks, 3), nsmall = 2)
    ) +
    ggplot2::scale_y_continuous("Standard Error", limits = c(0, .4)) +
    ggplot2::facet_grid(. ~ Group)
  if (!missing(title)) {
    plot <- plot + ggplot2::ggtitle(title)
  }
  return(plot)
}

library(tidyverse)
library(grid)

args <- commandArgs(trailingOnly = TRUE)
database <- as.character(args[1])

ncFile <- paste0(paste("negativeControls", database, sep = "_"), ".rds")

negativeControls <- readRDS(file.path("data/framework", ncFile)) %>%
  filter(
    !is.na(seLogRr),
    analysisType == "ps_strat_acute_myocardial_infarction"
  ) %>%
  mutate(
    database = toupper(database),
    riskStratum = factor(
      riskStratum,
      levels = paste0("Q", 1:3),
      labels = paste("RG", 1:3, sep = "-")
    )
  )

riskStrata <- unique(negativeControls$riskStratum)
plotList <- list()
for (i in seq_along(riskStrata)) {
  ncs <- negativeControls %>%
    filter(riskStratum == riskStrata[i])

  plotList[[i]] <- generateNcPlot(
    logRr = log(ncs$estimate),
    seLogRr = ncs$seLogRr,
    trueLogRr = rep(0, nrow(ncs)),
    title = riskStrata[i]
  ) +
    theme(
      plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "#F0F2F3"),
      axis.title.x = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_blank(),
      axis.text.x = element_blank()
    )
}

gridList <- list(
  plotList[[1]] +
    theme(
      plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "#F0F2F3"),
      axis.title.x = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_blank(),
      axis.text.x = element_text(size = 10),
      axis.ticks = element_blank(),
      strip.text.x = element_blank(),
      strip.text.y = element_blank(),
      strip.background = ggplot2::element_blank(),
      panel.spacing    = unit(0, "mm"),
      plot.margin = unit(c(4, 0, 0, 0), "mm"),
      plot.title = element_text(size = 18)
    ),
  plotList[[2]] +
    theme(
      plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "#F0F2F3"),
      axis.title = element_blank(),
      axis.text.x = element_text(size = 10),
      axis.text.y = element_blank(),
      axis.ticks = element_blank(),
      strip.text.x = element_blank(),
      strip.text.y = element_blank(),
      strip.background = ggplot2::element_blank(),
      panel.spacing    = unit(0, "mm"),
      plot.margin = unit(c(4, 0, 0, 0), "mm"),
      plot.title = element_text(size = 18)
    ),
  plotList[[3]] +
    theme(
      plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "#F0F2F3"),
      axis.title = element_blank(),
      axis.text.x = element_text(size = 10),
      axis.text.y = element_blank(),
      axis.ticks = element_blank(),
      strip.text.x = element_blank(),
      strip.text.y = element_blank(),
      strip.background = ggplot2::element_blank(),
      panel.spacing    = unit(0, "mm"),
      plot.margin = unit(c(4, 0, 0, 0), "mm"),
      plot.title = element_text(size = 18)
    )
)

bottom <- textGrob("Relative risk", gp = gpar(fontsize = 14))
left <- textGrob("Standard error", gp = gpar(fontsize = 14), rot = 90)



plot <- gridExtra::grid.arrange(
  grobs = gridList,
  nrow  = 1,
  bottom = bottom,
  left = left
)

# plot <- gridExtra::grid.arrange(pp[[1]], pp[[2]], pp[[3]], nrow = 3)

fileName <- paste0(
  paste(
    "ch3-NegativeControlsRiskStratified",
    database,
    sep = "_"
  ),
  ".tiff"
)
ggsave(
  file.path(
    "figures",
    fileName
  ),
  plot,
  height = 5.5,
  width = 8,
  dpi = 1000,
  compression = "lzw+p",
  bg = "#F1F3F8"
)
