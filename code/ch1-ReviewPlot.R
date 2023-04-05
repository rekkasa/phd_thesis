#!/usr/bin/env Rscript

library(tidyverse)

p <- data.frame(
  year = 1999:2019,
  riskBased = c(1, rep(0, 6), 1, 0, 1, 0, 1, 1, 0, 1, 1, 2, 1, 0, 0, 1),
  tem = c(rep(0, 12), 1, 0, 1, 1, 3, 0, 2, 1, 0),
  otr = c(rep(0, 12), 2, 2, 2, 1, 3, 0, 2, 0, 0),
  modelSelection = c(rep(0, 8), 1, 0, 1, rep(0, 8), 2, 0)
) %>%
  tidyr::pivot_longer(
    cols = riskBased:modelSelection,
    names_to = "method",
    values_to = "publications"
  ) %>%
  dplyr::mutate(
    method = factor(
      method,
      levels = c("riskBased", "tem", "otr", "modelSelection"),
      labels = c(
        "Risk based",
        "Treatment effect modeling",
        "Optimal treatment regime",
        "Model selection"
      )
    )
  ) %>%
  ggplot2::ggplot(ggplot2::aes(x = year, y = publications, fill = method)) +
  ggplot2::geom_bar(position = "stack", stat = "identity") +
  # geom_text(aes(label = publications), color="black", size=3.5) +
  ggplot2::xlab("Year of publication") +
  ggplot2::scale_x_continuous(breaks = 1999:2019) +
  ggplot2::scale_y_continuous(breaks = 1:8, expand = c(0, 0)) +
  ggplot2::scale_fill_manual(
    breaks = c(
      "Risk based",
      "Treatment effect modeling",
      "Optimal treatment regime",
      "Model selection"
    ),
    values = rev(c(
      "#D95980",
      "#63AAC0",
      "#F99B45",
      "#284E60"
    ))
  ) +
  ggplot2::theme(
    panel.grid.minor = ggplot2::element_blank(),
    panel.grid.major.x = ggplot2::element_blank(),
    plot.background = ggplot2::element_rect(fill = "#F1F3F8", color = NA),
    panel.background = ggplot2::element_rect(fill = "#F0F2F3", color = "black", linetype = 1),
    legend.position = c(.23, .82),
    legend.title = ggplot2::element_blank(),
    legend.box.background = ggplot2::element_rect(color = "black"),
    legend.background = ggplot2::element_rect(fill = "#F1F3F8"),
    axis.title.y = ggplot2::element_blank(),
    axis.title.x = ggplot2::element_text(size = 8.5),
    axis.text.x = ggplot2::element_text(size = 7, angle = 45, vjust = 0.9, hjust = 1),
    axis.text.y = ggplot2::element_text(size = 7),
    axis.line = ggplot2::element_line(color = "black")
  )


  ggplot2::ggsave(
    "figures/reviewFigure.tiff",
    plot = p,
    height = 4,
    width = 6,
    dpi = 1000,
    compression = "lzw+p"
  )
