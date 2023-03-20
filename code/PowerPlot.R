#!/usr/bin/env Rscript

calculatePower <- function(modifier, power) {
  .basePower <- function(power) 1.96 + qnorm(power, lower.tail = TRUE)
  modifiedEffectSize <- .basePower(power) * modifier / 2
  power <- pnorm(1.96, modifiedEffectSize, 1, lower.tail = FALSE)

  return(power)
}


result <- ggplot2::ggplot(
  data = data.frame(
    modifier = seq(0, 4, length.out = 1000)
  ),
  ggplot2::aes(x = modifier)
) +
  ggplot2::geom_function(
    fun = calculatePower,
    args = list(power = .5),
    ggplot2::aes(color = "50%")
  ) +
  ggplot2::geom_function(
    fun = calculatePower,
    args = list(power = .8),
    ggplot2::aes(color = "80%")
  ) +
  ggplot2::geom_function(
    fun = calculatePower,
    args = list(power = .9),
    ggplot2::aes(color = "90%")
  ) +
  ggplot2::scale_color_manual(
    name = "Power for main effect",
    values = c(
      "#FF6232",
      "#005270",
      "#8E194C"
    )
  )+
  ggplot2::xlab("Effect size") +
  ggplot2::ylab("Power for interaction") +
  ggplot2::theme_classic() +
  ggplot2::theme(
    legend.position = c(.18, .89)
  )

ggplot2::ggsave(
  "figures/PowerPlot.tiff",
  plot = result,
  width = 150,
  height = 120,
  units = "mm",
  compression = "lzw",
  dpi = 500
)
