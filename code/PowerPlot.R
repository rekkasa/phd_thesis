#!/usr/bin/env Rscript

message("Generating power plot figure of introduction...")

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
    ggplot2::aes(color = "50%"),
    linewidth = 1.5
  ) +
  ggplot2::geom_function(
    fun = calculatePower,
    args = list(power = .8),
    ggplot2::aes(color = "80%"),
    linewidth = 1.5
  ) +
  ggplot2::geom_function(
    fun = calculatePower,
    args = list(power = .9),
    ggplot2::aes(color = "90%"),
    linewidth = 1.5
  ) +
  ggplot2::scale_color_manual(
    name = "Power for main effect",
    values = c(
      "#FF6232",
      "#005270",
      "#8E194C"
    )
  ) +
  ggplot2::xlab("Effect size") +
  ggplot2::ylab("Power for interaction") +
  ggplot2::theme(
    legend.position = c(.13, .86),
    axis.text = ggplot2::element_text(size = 18),
    axis.title = ggplot2::element_text(size = 20),
    axis.ticks = ggplot2::element_blank(),
    axis.line = ggplot2::element_line(linewidth = 1, color = "black"),
    plot.background = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    panel.grid.major.x = ggplot2::element_blank(),
    panel.background = ggplot2::element_rect(fill = "#F0F2F3"),
    legend.title = ggplot2::element_blank(),
    legend.text = ggplot2::element_text(size = 18),
    # legend.box.background = ggplot2::element_rect(color = "black"),
    legend.box.background = ggplot2::element_blank(),
    legend.background = ggplot2::element_rect(fill = "#F1F3F8")
  )

ggplot2::ggsave(
  "figures/PowerPlot.tiff",
  plot = result,
  height = 6,
  width = 8,
  dpi = 1000,
  compression = "lzw+p",
  bg = "#F0F2F3"
)

message(
  crayon::green(
    paste(
      "\u2713 Figure saved at:",
      "figures/PowerPlot.tiff"
    )
  )
)
