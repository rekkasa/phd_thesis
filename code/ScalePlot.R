#!/usr/bin/env Rscript

oddsRatio <- function(p0, d) {
  res <- ((p0 - d) * (1 - p0)) / (p0 * (1 - p0 + d))
  return(res)
}

absoluteRiskDifference <- function(p0, oddsRatio) {
  .expit <- function(x) exp(x) / (1 + exp(x))
  .logit <- function(x) log(x / (1 - x))
  gamma <- log(oddsRatio)
  lp0 <- .logit(p0)
  res <- p0 - .expit(lp0 + gamma)

  res
}


arr <-  ggplot2::ggplot(
  data = data.frame(
    p0 = seq(.05, .99, length.out = 1e3)
  ),
  ggplot2::aes(x = p0)
) +
  ggplot2::xlab("Baseline risk") +
  ggplot2::ylab("Absolute risk reduction") +
  ggplot2::scale_x_continuous(limits = c(0, 1)) +
  ggplot2::scale_y_continuous(
    limits = c(0, .1),
    breaks = seq(0, .1, by = .02),
    labels = scales::number_format(accuracy = .01)
  ) +
  ggplot2::geom_function(
    fun = absoluteRiskDifference,
    args = list(oddsRatio = .8)
  ) +
  ggplot2::theme_classic()


rrr <- ggplot2::ggplot(
  data = data.frame(
    p0 = seq(.05, .99, length.out = 1e3)
  ),
  ggplot2::aes(x = p0)
) +
  ggplot2::xlab("Baseline risk") +
  ggplot2::ylab("Odds ratio") +
  ggplot2::scale_x_continuous(
    limits = c(0, 1),
    breaks = seq(0, 1, by = .25)
  ) +
  ggplot2::scale_y_continuous(
    limits = c(0, 1),
    breaks = seq(0, 1, by = .2),
    labels = scales::number_format(accuracy = .01)
  ) +
  ggplot2::geom_function(
    fun = oddsRatio,
    args = list(d = .05)
  ) +
  ggplot2::theme_classic() 

plotList <- list(arr, rrr)

result <- cowplot::plot_grid(
  plotList[[1]],
  plotList[[2]],
  nrow = 1
)

ggplot2::ggsave(
  "figures/ScalePlot.tiff",
  plot = result,
  width = 150,
  height = 100,
  units = "mm",
  compression = "lzw",
  dpi = 500
)
